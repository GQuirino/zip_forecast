require 'swagger_helper'

RSpec.describe 'api/v1/forecasts', type: :request, swagger: true do
  path '/api/v1/forecasts' do
    get 'Retrieves a weather forecast by address' do
      tags 'Forecasts'
      produces 'application/json'
      parameter name: 'address[city]', in: :query, type: :string, required: false, description: 'City name'
      parameter name: 'address[state]', in: :query, type: :string, required: false, description: 'State code'
      parameter name: 'address[zip]', in: :query, type: :string, required: false, description: 'Zip code'
      parameter name: 'address[street]', in: :query, type: :string, required: false, description: 'Street address'
      parameter name: :days, in: :query, type: :integer, required: false, description: 'Number of days for forecast (1-14)', minimum: 1, maximum: 14
      parameter name: :unit, in: :query, type: :string, required: false, description: 'Unit system (imperial or metric)', enum: [ 'imperial', 'metric' ]

      response '200', 'Success' do
        schema type: :object,
          properties: {
            cached: { type: :boolean },
            current: {
              type: :object,
              properties: {
                condition: { type: :string },
                uv: { type: :number },
                temperature: { type: :number },
                wind: {
                  type: :object,
                  properties: {
                    speed: { type: :number },
                    direction: {
                      type: :object,
                      properties: {
                        degree: { type: :integer },
                        dir: { type: :string }
                      }
                    }
                  }
                },
                feels_like: { type: :number }
              }
            },
            forecast: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  day: { type: :string },
                  max: { type: :number },
                  min: { type: :number },
                  condition: { type: :string },
                  humidity: { type: :integer },
                  chance_of_rain: { type: :integer },
                  chance_of_snow: { type: :integer },
                  hourly: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        time: { type: :string },
                        temperature: { type: :number },
                        condition: { type: :string },
                        feels_like: { type: :number }
                      }
                    }
                  }
                }
              }
            }
          },
          required: [ 'cached', 'current', 'forecast' ]

        let('address[city]') { 'Los Angeles' }
        let('address[state]') { 'CA' }
        let('address[zip]') { '90001' }
        let('address[street]') { '123 Main St' }
        let(:unit) { 'imperial' }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
         schema type: :object,
         properties: {
           errors: {
             type: :object,
             properties: {
               street: { type: :array, items: { type: :string } },
               city: { type: :array, items: { type: :string } },
               state: { type: :array, items: { type: :string } },
               zip: { type: :array, items: { type: :string } }
             }
           }
         }

        let('address[city]') { '' }
        let('address[state]') { '' }
        let('address[zip]') { '' }
        let('address[street]') { '' }

        run_test!
      end
    end
  end
end
