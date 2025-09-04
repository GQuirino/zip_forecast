module Api
  module V1
    class ForecastsController < ApplicationController
      rescue_from Adapters::WeatherApi::HttpAdapter::Error, with: :handle_error
      rescue_from ActiveModel::ValidationError, with: :handle_error

      def index
        address = Address.new(address_params)
        address.validate!

        @forecast = ForecastService.new(zip: address.zip, days: forecast_days).call
        render "show_#{unit_system}", status: :ok
      end

      private

      def unit_system
        params[:unit].presence_in(%w[imperial metric]) || "imperial"
      end

      def forecast_days
        # Ensure param days is an integer value
        Integer(params[:days]) rescue 1
      end

      def address_params
        params.require(:address).permit(:street, :city, :state, :zip)
      end

      def handle_error(error)
        render json: { error: error.message }, status: :unprocessable_entity
      end
    end
  end
end
