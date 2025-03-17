class ChatsController < ApplicationController
  before_action :chat, only: %i[show]

  def index
    @chats = Chat.all
    @chat_last = Chat.last
    @chat = Chat.new

    @chats_by_period = format_periods
  end

  def show
    @reasoning_content = chat.reasoning_content
    @chat_result = chat.result
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      response = DeepseekApi::DeepseekClient.new.call(chat_params[:content], @chat)

      reasoning_content = response["reasoning_content"]
      content = response["content"]

      html_reasoning_content = Kramdown::Document.new(response["reasoning_content"]).to_html if response["reasoning_content"].present?
      html_content = Kramdown::Document.new(content).to_html

      @chat.update(result: html_content, reasoning_content: html_reasoning_content)

      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("chat_frame", template: "chats/show") }
        format.html { redirect_to chat_path(@chat), status: :see_other }
      end

      # redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:content, :deepseek_model_name, :deepseek_model_role, :temperature, :max_tokens, :stream, :top_p)
  end

  def chat
    @chat ||= Chat.find(params[:id])
  end

  def format_periods
    periods = {
      today: Chat.today.order(created_at: :desc),
      yesterday: Chat.yesterday.order(created_at: :desc),
      last_7_days: Chat.last_7_days - Chat.today - Chat.yesterday,
      last_30_days: Chat.last_30_days - Chat.last_7_days
    }

    periods.delete_if { |_, tasks| tasks.empty? }
  end
end
