class ChatsController < ApplicationController
  before_action :chat, only: %i[show edit update destroy]

  def index
    @chats = Chat.all
    @chat = Chat.new
    @message = @chat.messages.build
    @setting = @message.build_setting

    @chats_by_period = format_periods
  end

  def show
    @messages = @chat.messages.order(created_at: :asc)
    @new_chat = Chat.new
    @message = @new_chat.messages.build
    @setting = @message.build_setting

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("chat_frame", template: "chats/show")
      ]
      end
      format.html
    end
  end

  def new
    @chat = Chat.new
    @message = @chat.messages.build
    @setting = @message.build_setting

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("chat_frame", template: "chats/new")
      ]
      end
      format.html
    end
  end

  def edit; end

  def create
    @chat = Chat.new(chat_params)

    if @chat.valid?
      @chat.save

      content =  @chat.messages.last.content
      deepseek_model_role = @chat.messages.last.deepseek_model_role
      settings = @chat.messages.last.setting

      response = DeepseekApi::DeepseekClient.new.call(content, deepseek_model_role, settings)

      if response["reasoning_content"].present?
        reasoning_content = Kramdown::Document.new(response["reasoning_content"]).to_html
      end

      answer_content = Kramdown::Document.new(response["content"]).to_html

      @chat.messages.last.update(content: content, result: answer_content, reasoning_content: reasoning_content)

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
    params.require(:chat).permit(:title,
      messages_attributes: [ :id, :deepseek_model_role, :content, :result, :reasoning_content, :_destroy,
      setting_attributes: [ :id, :deepseek_model_name, :temperature, :max_tokens, :top_p, :stream, :_destroy ] ])
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
