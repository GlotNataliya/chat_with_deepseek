module DeepseekApi
  class DeepseekClient
    API_BASE_URL = "https://api.deepseek.com/v1".freeze
    DEFAULT_MODEL = "deepseek-chat".freeze

    def initialize
      @api_key = ENV.fetch("DEEPSEEK_API_KEY")
      validate_api_key!
    end

    def call(prompt, object)
      connection.post("/chat/completions", build_request_body(prompt, object)).then do |response|
        handle_response(response)
      end
    rescue Faraday::Error => e
      handle_error(e)
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

    def build_request_body(prompt, object)
      params = {
        model: object.model || DEFAULT_MODEL,
        messages: [
          { role: object.role || "user", content: prompt }   # "json #{prompt}"
        ],
        temperature: object.temperature,
        max_tokens: object.max_tokens,
        top_p: object.top_p,
        stream: object.stream
      }

      # params.merge!(
      #   response_format: { type: "json_object" }
      # ) if object.model == "deepseek-chat"

      params
    end

    def handle_response(response)
      case response.status
      when 200..299
        result = response.body.dig("choices", 0, "message", "content")
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
      raise "Service unavailable: #{error.message}"
    end

    def validate_api_key!
      raise "Missing API Key" if @api_key.blank?
    end
  end
end
