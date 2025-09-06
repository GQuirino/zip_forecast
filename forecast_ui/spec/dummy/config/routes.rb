Rails.application.routes.draw do
  mount ForecastUi::Engine => "/"
  
  root to: "forecast_ui/home#index"
  namespace :api do
    namespace :v1 do
      resources :forecasts, only: [:index, :create]
    end
  end
end
