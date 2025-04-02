module DeepseekApi
  class DeepseekClient
    API_BASE_URL = "https://api.deepseek.com/v1".freeze
    DEFAULT_MODEL = "deepseek-chat".freeze

    def initialize
      @api_key = ENV.fetch("DEEPSEEK_API_KEY")
      validate_api_key!
    end

    def call(message, messages_data = nil)
      connection.post("/chat/completions", build_request_body(message, messages_data)).then do |response|
        handle_response(response)
      end
      rescue Faraday::Error => e
        handle_error(e)
      rescue Net::ReadTimeout => e
        handle_timeout_error(e)
      rescue StandardError => e
        handle_general_error(e)
    end

    private

    def connection
      @connection ||= Faraday.new(
        url: API_BASE_URL,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{@api_key}"
        }
      ) do |f|
        f.request :json
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end

    def build_request_body(message, messages_data)
      setting = message.setting
      deepseek_model_role = message.deepseek_model_role
      first_message = message.chat.messages.first
      deepseek_settings = {
        model: setting.deepseek_model_name || DEFAULT_MODEL,
        response_format: { type: "text" },
        temperature: setting.temperature,
        max_tokens: setting.max_tokens,
        top_p: setting.top_p,
        stream: setting.stream
      }

      if message.add_assistant == true
        deepseek_settings[:messages] = [
          { role: "system", content: message.assistant_prompt },
          { role: deepseek_model_role || "user", content: message.content }
        ]
      else
        deepseek_settings[:messages] = [ { role: deepseek_model_role || "user", content: message.content } ]
      end

      if first_message.add_assistant == true && messages_data.present?
        deepseek_settings[:messages].unshift(*messages_data)
        deepseek_settings[:messages].unshift({ role: "system", content: first_message.assistant_prompt })
      elsif messages_data.present?
        deepseek_settings[:messages].unshift(*messages_data)
      end
      deepseek_settings
    end

    def handle_response(response)
      case response.status
      when 200..299
        response.body.dig("choices", 0, "message")
      when 400..499
        raise DeepseekApi::Error, "Client error: #{response.status} - #{response.body&.dig('error', 'message') || response.body}"
      when 500..599
        raise DeepseekApi::Error, "Server error: #{response.status} - #{response.body&.dig('error', 'message') || response.body}"
      else
        raise DeepseekApi::Error, "Unexpected error: #{response.status} - #{response.body}"
      end
    end

    def handle_error(error)
      Rails.logger.error("Deepseek API Error: #{error.message}")
    end

    def handle_timeout_error(error)
      Rails.logger.error("Timeout Error: #{error.message}")
    end

    def handle_general_error(error)
      Rails.logger.error("Unexpected Error: #{error.message}")
    end

    def validate_api_key!
      raise "Missing API Key" if @api_key.blank?
    end
  end
end
