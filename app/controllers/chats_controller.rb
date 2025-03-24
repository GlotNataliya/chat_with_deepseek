class ChatsController < ApplicationController
  before_action :chat, only: %i[show edit update destroy]

  def index
    @chats = Chat.all
    @chat_last = Chat.last
    @chat = Chat.new

    @chats_by_period = format_periods
  end

  def show
    @reasoning_content = chat.reasoning_content
    @answer_content = chat.result
  end

  def new
    @chat = Chat.new
  end

  def edit; end

  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      response = DeepseekApi::DeepseekClient.new.call(chat_params[:content], @chat)

      @reasoning_content = Kramdown::Document.new(response["reasoning_content"]).to_html if response["reasoning_content"].present?
      @answer_content = Kramdown::Document.new(response["content"]).to_html

      @chat.update(result: @answer_content, reasoning_content: @reasoning_content)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("chat_frame", template: "chats/show")
          ]
        end
        format.html { redirect_to chat_path(@chat), status: :see_other }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if chat.update(title: chat_params[:title])
      redirect_to chats_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    chat.destroy
    redirect_to chats_path
  end

  private

  def chat_params
    params.require(:chat).permit(:title, :content, :deepseek_model_name, :deepseek_model_role, :temperature, :max_tokens, :stream, :top_p)
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
