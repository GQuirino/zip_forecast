Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"

  mount ForecastUi::Engine => "/"

  namespace :api do
    namespace :v1 do
      resources :forecasts, only: [ :index ]
    end
  end
end
