ForecastUi::Engine.routes.draw do
  root to: "home#index"
  get "loading", to: "home#loading"
  post "forecasts", to: "home#forecasts"
end
