
# Zip Forecast

A Ruby on Rails API with a simple web interface for weather forecasts by address

## Features
- Weather forecast lookup by address
- Unit system support (imperial/metric)
- Forecast for next x days (from 1 up to 14 days)

## Requirements
- Ruby 3.3.x
- Rails 8.0.x
- Redis
  or
- Docker (for containerized development)

## Setup

### 1. Clone the repository
```sh
git clone https://github.com/GQuirino/zip_forecast.git
cd zip_forecast
```

### 2. Run with Docker Compose
```sh
docker-compose up --build
```

The Rails app will be available at [http://localhost:3000](http://localhost:3000)

### 3. Run tests and lint
```sh
bundle exec rubocop
bundle exec rspec
```

## API Documentation (Swagger)

Interactive API docs are available at:

- [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

The OpenAPI spec is served at:

- [http://localhost:3000/api-docs/v1/swagger.yaml](http://localhost:3000/api-docs/v1/swagger.yaml)


## UI
A simple web interface is available at:
- [http://localhost:3000](http://localhost:3000)

UI built as Rails::Engine component with Tailwind CSS.

## License
MIT
