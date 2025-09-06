require "rails_helper"

RSpec.describe ForecastUi::HomeController, type: :controller do
  routes { ForecastUi::Engine.routes }


  before do
    allow(controller.view_context).to receive(:main_app).and_return(
      double(api_v1_forecasts_path: "/api/v1/forecasts")
    )
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #loading" do
    it "renders the loading template" do
      get :loading
      expect(response).to render_template(partial: "forecast_ui/home/_loading")
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #forecasts" do
    before do
      allow(Net::HTTP).to receive(:get_response).and_return(api_response)
    end

    let(:api_body_success) do
      File.read(ForecastUi::Engine.root.join("spec/fixtures/success_main_app_response.json"))
    end

    let(:api_body_fail) do
      File.read(ForecastUi::Engine.root.join("spec/fixtures/fail_main_app_response.json"))
    end

    let(:api_invalid_response) do
      File.read(ForecastUi::Engine.root.join("spec/fixtures/invalid_main_app_response.json"))
    end

    let(:successful_response) { instance_double(Net::HTTPResponse, code: "200", body: api_body_success, message: "OK") }
    let(:failed_response) { instance_double(Net::HTTPResponse, code: "422", body: api_body_fail, message: "Unprocessable Entity") }
    let(:invalid_response) { instance_double(Net::HTTPResponse, code: "200", body: api_invalid_response, message: "OK") }

    context "with successful API response" do
      let(:api_response) { successful_response }
      render_views

      it "renders the forecast_result partial with correct locals" do
        post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" } }
        expect(response).to render_template(partial: "forecast_ui/home/_forecast_result")
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("66.2° F")
        expect(response.body).to include("17.6 mph")
      end

      it "calls Net::HTTP.get_response with the correct URI" do
        expected_uri = URI("http://test.host/api/v1/forecasts.json?address%5Bcity%5D=Los+Angeles&address%5Bstate%5D=CA&address%5Bstreet%5D=123+Main+St&address%5Bzip%5D=90210&unit=imperial")
        expect(Net::HTTP).to receive(:get_response).with(expected_uri).and_return(api_response)
        post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" } }
      end
    end

    context "with API error response" do
      let(:api_response) { failed_response }
      render_views

      it "renders the error partial with correct locals" do
        post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "ABCD" } }
        expect(response).to render_template(partial: "forecast_ui/home/_error")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Zip must be a valid ZIP code")
      end
    end

    context "when an exception occurs" do
      let(:api_response) { invalid_response }
      render_views

      it "renders the error partial with exception message" do
        post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" } }
        expect(response).to render_template(partial: "forecast_ui/home/_error")
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Error Getting Forecast")
      end
    end

    context "params" do
      context "when unit param is metric" do
        let(:api_response) { successful_response }
        render_views

        it "uses metric units in the API call" do
          expect(Net::HTTP).to receive(:get_response).with(/unit=metric/)
          post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" }, unit: "metric" }
        end

        it "sets temperature and velocity units correctly" do
          post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" }, unit: "metric" }
          expect(response.body).to include("° C")
          expect(response.body).to include("km/h")
          expect(response.body).to_not include("° F")
          expect(response.body).to_not include("mph")
        end
      end

      context "when unit param is imperial" do
        let(:api_response) { successful_response }
        render_views

        it "uses imperial units in the API call" do
          expect(Net::HTTP).to receive(:get_response).with(/unit=imperial/)
          post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" }, unit: "imperial" }
        end

        it "sets temperature and velocity units correctly" do
          post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" }, unit: "imperial" }
          expect(response.body).to include("° F")
          expect(response.body).to include("mph")
          expect(response.body).to_not include("° C")
          expect(response.body).to_not include("km/h")
        end
      end

      context "when unit param is missing or invalid" do
        let(:api_response) { successful_response }
        render_views

        it "defaults to imperial units in the API call" do
          expect(Net::HTTP).to receive(:get_response).with(/unit=imperial/)
          post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" } }
        end
      end

      context "address params" do
        let(:api_response) { successful_response }
        render_views

        it "includes the address params in the API call" do
            expect(Net::HTTP).to receive(:get_response).with(
              a_string_matching(/address%5Bcity%5D=Los\+Angeles.*address%5Bstate%5D=CA.*address%5Bstreet%5D=123\+Main\+St.*address%5Bzip%5D=90210.*unit=imperial/)
            ).and_return(api_response)
            post :forecasts, params: { address: { street: "123 Main St", city: "Los Angeles", state: "CA", zip: "90210" } }
        end

        it "still builds api_params without raising errors when missing" do
          expect(Net::HTTP).to receive(:get_response).with(
            a_string_matching(/unit=imperial/)
          ).and_return(api_response)

          post :forecasts, params: { unit: "imperial" }

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
