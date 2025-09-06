require "rails_helper"

RSpec.describe "ForecastUi", type: :request do
  it "renders the home page" do
    get "/"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Forecast Lookup") # Page title
    # check fields presence
    expect(response.body).to include("address[street]")
    expect(response.body).to include("address[city]")
    expect(response.body).to include("address[state]")
    expect(response.body).to include("address[zip]")
    expect(response.body).to include("unit")
    expect(response.body).to include("days")

    expect(response.body).to include("Get Forecast")
  end
end
