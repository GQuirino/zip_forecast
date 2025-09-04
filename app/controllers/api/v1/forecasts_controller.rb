module Api
  module V1
    class ForecastsController < ApplicationController
      include Turbo::StreamsHelper

      rescue_from Adapters::WeatherApi::HttpAdapter::Error, with: :handle_http_adapter_error

      def index
        if address.valid?
          @forecast = ForecastService.new(zip: address.zip, days: forecast_in_days).call

          respond_to do |format|
            format.json do
              if unit_system == "metric"
                render :show_metric, status: :ok
              else
                render :show_imperial, status: :ok
              end
            end
          end
        else
          respond_to do |format|
            format.json do
              render json: { errors: address.errors.as_json }, status: :unprocessable_content
            end
          end
        end
      end

      private

      def address
        @address ||= Address.new(address_params)
      end

      def unit_system
        permitted_params[:unit].presence_in(%w[imperial metric]) || "imperial"
      end

      def forecast_in_days
        days = permitted_params[:days].to_i
        return ForecastService::MAX_DAYS if days > ForecastService::MAX_DAYS

        days
      end

      def address_params
        permitted_params[:address]
      end

      def permitted_params
        params.permit(
          { address: [ :street, :city, :state, :zip ] },
          :days,
          :unit)
      end

      def forecast_adapter
        Adapters::WeatherApi::HttpAdapter.new
      end

      def handle_http_adapter_error(error)
        respond_to do |format|
          format.json do
            render json: { error: error.message }, status: :unprocessable_content
          end
        end
      end
    end
  end
end
