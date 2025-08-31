json.cached @forecast[:cached]
json.current do
  json.condition @forecast["current"]["condition"]["text"]
  json.uv @forecast["current"]["uv"]
  json.temperature @forecast["current"]["temp_f"]
  json.wind do
    json.speed @forecast["current"]["wind_kph"]
    json.direction do
      json.degree @forecast["current"]["wind_degree"]
      json.dir @forecast["current"]["wind_dir"]
    end
  end
  json.feels_like @forecast["current"]["feelslike_f"]
end
json.forecast @forecast["forecast"]["forecastday"] do |forecast|
  json.day forecast["date"]
  json.max forecast["day"]["maxtemp_f"]
  json.min forecast["day"]["mintemp_f"]
  json.condition forecast["day"]["condition"]["text"]
  json.humidity forecast["day"]["avghumidity"]
  json.chance_of_rain forecast["day"]["daily_chance_of_rain"]
  json.chance_of_snow forecast["day"]["daily_chance_of_snow"]
  json.hourly forecast["hour"] do |hour|
    json.time hour["time"]
    json.temperature hour["temp_f"]
    json.condition hour["condition"]["text"]
    json.feels_like hour["feelslike_f"]
  end
end
