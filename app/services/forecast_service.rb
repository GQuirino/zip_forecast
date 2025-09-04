class ForecastService
  attr_reader :zip, :days
  
  def initialize(zip:, days:)
    @zip = zip
    @days = [days, MAX_DAYS].min
  end
  
  def call
    cached_result || fetch_and_cache
  end
  
  private

  MAX_DAYS = 14

  def cache_key
    "forecast:#{zip}:#{days}"
  end

  def expires_in
    30.minutes
  end

  def forecast_adapter
    Adapters::WeatherApi::HttpAdapter.new
  end

  def cached_result
    cached = Rails.cache.read(cache_key)
    return unless cached
    JSON.parse(cached).merge(cached: true)
  end

  def fetch_and_cache
    result = forecast_adapter.get_forecast(zip:, days:)
    Rails.cache.write(cache_key, result.to_json, expires_in:)
    result.merge(cached: false)
  end
end
