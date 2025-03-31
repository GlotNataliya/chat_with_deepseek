class MessagesController < ApplicationController
  before_action :set_chat, only: [ :create ]

  def create
    @message = @chat.messages.build(message_params)

    if @message.valid?
      @message.save
      content =  @message.content
      deepseek_model_role = @message.deepseek_model_role
      setting = @message.setting
      previous_messages = @chat.messages.where("id < ?", @chat.messages.maximum(:id))
      messages_data = previous_messages.pluck(:deepseek_model_role, :content, :result).flat_map do |role, content, result|
        [
          { role: role, content: content },
          { role: "assistant", content: result }
        ]
      end

      response = DeepseekApi::DeepseekClient.new.call(content, deepseek_model_role, setting, messages_data)

      if response["reasoning_content"].present?
        reasoning_content = Kramdown::Document.new(response["reasoning_content"]).to_html
      end

      answer_content = Kramdown::Document.new(response["content"]).to_html

      @message.update(content: content, result: answer_content, reasoning_content: reasoning_content)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("chat_frame", template: "chats/show")
          ]
        end
        format.html { redirect_to chat_path(@chat), status: :see_other }
      end
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:chat_id, :deepseek_model_role, :content, :result, :reasoning_content,
            setting_attributes: [ :id, :deepseek_model_name, :temperature, :max_tokens, :top_p, :stream, :_destroy ])
  end
end
