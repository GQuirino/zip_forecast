require 'rails_helper'

RSpec.describe Adapters::WeatherApi::HttpAdapter do
  let(:adapter) { described_class.new }

  describe '#get_forecast' do
    it 'returns a forecast for a valid zip code' do
      VCR.use_cassette('weather_api/valid_zip_90210_days_2') do
        response = adapter.get_forecast(zip: '90210', days: 2)
        expect(response.code).to eq(200)
        expect(response.parsed_response).to have_key('location')
        expect(response.parsed_response).to have_key('forecast')
        expect(response.parsed_response["forecast"]["forecastday"].size).to eq(2)
      end
    end

    it 'returns an error for an invalid zip code' do
      VCR.use_cassette('weather_api/invalid_zip') do
        expect do
          adapter.get_forecast(zip: '00000', days: 1)
        end.to raise_error(Adapters::WeatherApi::HttpAdapter::Error)
          .with_message("No matching location found.")
      end
    end

    it 'includes days in the query if days is present' do
      VCR.use_cassette('weather_api/valid_zip_90210_days_5') do
        expect(HTTParty).to receive(:get).with(/\/forecast\.json/, hash_including(query: hash_including(days: 5))).and_call_original
        adapter.get_forecast(zip: '90210', days: 5)
      end
    end

    it 'does not include days in the query if days is nil' do
      VCR.use_cassette('weather_api/valid_zip_90210_days_nil') do
        expect(HTTParty).to receive(:get).with(/\/forecast\.json/, hash_including(query: hash_excluding(:days))).and_call_original
        adapter.get_forecast(zip: '90210', days: nil)
      end
    end
  end
end
