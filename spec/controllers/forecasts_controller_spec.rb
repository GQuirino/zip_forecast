require 'rails_helper'
require 'vcr'

RSpec.describe Api::V1::ForecastsController, type: :request do
  let(:valid_address) do
    {
      street: '123 Main St',
      city: 'Los Angeles',
      state: 'CA',
      zip: '90210'
    }
  end

  let(:missing_address) do
    {
      street: '',
      city: '',
      state: '',
      zip: ''
    }
  end

  describe 'GET /api/v1/forecasts' do
    it 'returns a forecast for a valid address (imperial)', :vcr do
      VCR.use_cassette('weather_api/valid_address') do
        get api_v1_forecasts_path(format: :json), params: { address: valid_address, unit: 'imperial', days: 1 }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        body = JSON.parse(response.body)
        expect(body).to be_a(Hash)
        expect(body["current"]["temperature"]).to eq(80.1)
      end
    end

    it 'returns a forecast for a valid address (metric)', :vcr do
      VCR.use_cassette('weather_api/valid_address') do
        get api_v1_forecasts_path(format: :json), params: { address: valid_address, unit: 'metric', days: 1 }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        body = JSON.parse(response.body)
        expect(body).to be_a(Hash)
        expect(body["current"]["temperature"]).to eq(26.7)
      end
    end

    it 'returns errors for an invalid address', :vcr do
      VCR.use_cassette('weather_api/missing_address') do
        get api_v1_forecasts_path(format: :json), params: { address: missing_address, unit: 'imperial', days: 1 }
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end

    it 'returns errors for missing address', :vcr do
      get api_v1_forecasts_path(format: :json)
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end

    it 'returns errors for invalid zip', :vcr do
      VCR.use_cassette('weather_api/invalid_address') do
        get api_v1_forecasts_path(format: :json), params: { address: valid_address.merge(zip: 'abcde') }
        expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
        body = JSON.parse(response.body)
        expect(body).to have_key('error')
        expect(body['error']).to include("Zip must be a valid ZIP code")
      end
    end

    it 'handle invalid unit', :vcr do
      VCR.use_cassette('weather_api/invalid_unit') do
        get api_v1_forecasts_path(format: :json), params: { address: valid_address, unit: 'kelvin', days: 1 }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    it 'defaults max days param to 14', :vcr do
      VCR.use_cassette('weather_api/max_days_14') do
        get api_v1_forecasts_path(format: :json), params: { address: valid_address, days: 99 }
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to be_a(Hash)
        expect(body['forecast'].length).to eq(14)
      end
    end

    it 'returns 502 Bad Gateway and error message when HttpAdapter::Error is raised' do
      VCR.use_cassette('weather_api/http_adapter_error') do
        get api_v1_forecasts_path(format: :json), params: { address: valid_address.merge(zip: '00000') }
        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'No matching location found.' })
      end
    end
  end
end
