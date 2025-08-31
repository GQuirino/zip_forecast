module Adapters
  module WeatherApi
    class HttpAdapter
      class Error < StandardError; end

      def initialize
        @base_url = Rails.application.config.weather_api[:base_url]
        @api_key = Rails.application.config.weather_api[:api_key]
      end

      def get_forecast(zip:, days:)
        query = { key: @api_key, q: zip }
        query[:days] = days if days
        response = HTTParty.get("#{@base_url}/forecast.json", query: query)

        raise Error, response.dig("error", "message") || response.message unless response.success?

        response
      end
    end
  end
end
