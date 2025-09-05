require 'rails_helper'
require 'vcr'

RSpec.describe ForecastService do
  let(:zip) { '90210' }
  let(:days) { 1 }
  let(:service) { described_class.new(zip: zip, days: days) }

  describe '#call' do
    it 'returns a forecast for a valid zip code and caches the result', :vcr do
      VCR.use_cassette('weather_api/valid_zip_90210_days_1') do
        result = service.call
        expect(result).to be_a(Hash)
        expect(result).to have_key('forecast')
        expect(result).to have_key(:cached)
        expect(result[:cached]).to eq(false)

        # Second call should be cached
        cached_result = service.call
        expect(cached_result[:cached]).to eq(true)
      end
    end

    it 'returns an error for an invalid zip code', :vcr do
      VCR.use_cassette('weather_api/invalid_zip') do
        expect do
          described_class.new(zip: '00000', days: days).call
        end.to raise_error(Adapters::WeatherApi::HttpAdapter::Error)
          .with_message("No matching location found.")
      end
    end
  end

  describe '#initialize' do
    it 'sets the zip and days attributes' do
      service = described_class.new(zip: '12345', days: 5)
      expect(service.zip).to eq('12345')
      expect(service.days).to eq(5)
    end

    it 'does not allows days greater than MAX_DAYS (14)' do
      service = described_class.new(zip: '12345', days: 20)
      expect(service.days).to eq(14)
    end

    it 'allows days less than MAX_DAYS' do
      service = described_class.new(zip: '12345', days: 7)
      expect(service.days).to eq(7)
    end

    it 'does not allow negative days' do
      service = described_class.new(zip: '12345', days: -3)
      expect(service.days).to eq(0)
    end
  end
end



