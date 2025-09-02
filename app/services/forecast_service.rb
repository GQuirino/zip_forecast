class ForecastService
  attr_accessor :zip, :days, :result

  MAX_DAYS = 14

  def initialize(zip:, days:)
    @zip = zip
    @days = days
    @result = {}
  end

  def call
    return cached_result if cached_result.present?

    result.merge!(forecast_adapter.get_forecast(zip:, days:))
    Rails.cache.write(cache_key, result.to_json, expires_in:)

    result.merge!(cached: false)
  end

  private

  def cache_key
    "forecast:#{@zip}:#{@days}"
  end

  def expires_in
    30.minutes
  end

  def forecast_adapter
    Adapters::WeatherApi::HttpAdapter.new
  end

  def cached_result
    result = Rails.cache.read(cache_key)
    return unless result

    result = JSON.parse(result)
    result.merge!(cached: true)
  end
end
