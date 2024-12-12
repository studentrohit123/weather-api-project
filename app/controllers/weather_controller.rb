class WeatherController < ApplicationController
  require 'httparty'

  def forecast
    city = params[:city]
    country = params[:country]
    api_key = ENV['WEATHER_API_KEY']
  
    response = HTTParty.get(
      'https://api.weatherbit.io/v2.0/forecast/daily',
      query: { city: city, country: country, key: api_key }
    )
    
    if response.success?

      data = response.parsed_response['data']

      if data && !data.empty? 
        current_temperature = data[0]['temp']
        weather_description = data[0]['weather']['description']
        current_date = Date.today

        render json: {
          city: response.parsed_response['city_name'],
          country: response.parsed_response['country_code'],
          temperature: current_temperature,
          description: weather_description,
          date: current_date
        }, status: 200
      else
      render json: { error: 'Weather data not found' }, status: :not_found
      end
    else
      render json: { error: response['message'] || 'Unable to fetch weather data' }, status: response.code
    end
  end
end 
