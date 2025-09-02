require "net/http"
require "json"

module ForecastUi
  class HomeController < ApplicationController
    def index
    end

    def loading
      render partial: "loading", layout: false
    end

    def forecasts
      # Get the unit system from params
      unit_system = params[:unit] || "imperial"

      # Build the API URL with all the address parameters
      api_params = {
        "address[street]" => params[:address]&.dig(:street),
        "address[city]" => params[:address]&.dig(:city),
        "address[state]" => params[:address]&.dig(:state),
        "address[zip]" => params[:address]&.dig(:zip),
        "unit" => unit_system,
        "days" => params[:days]
      }.compact

      api_url = "#{request.base_url}/api/v1/forecasts.json?#{api_params.to_query}"

      begin
        response = Net::HTTP.get_response(URI(api_url))

        if response.code == "200"
          forecast_data = JSON.parse(response.body)
          temperature_unit = unit_system == "metric" ? "C" : "F"
          velocity_unit = unit_system == "metric" ? "km/h" : "mph"

          render partial: "forecast_result", locals: {
            data: forecast_data,
            temperature_unit: temperature_unit,
            velocity_unit: velocity_unit
          }, layout: false
        else

          render partial: "error", locals: {
            status_code: response.code,
            error_message: "HTTP #{response.code}: #{response.message}",
            body: JSON.parse(response.body || "{}")
          }, layout: false, status: :unprocessable_entity
        end
      rescue => e
        render partial: "error", locals: {
          error_message: e.message
        }, layout: false, status: :unprocessable_entity
      end
    end
  end
end
