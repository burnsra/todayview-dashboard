require 'forecast_io'
require 'json'

# Forecast API Key from https://developer.forecast.io
forecast_api_key = "632678e1ce0b6ed2dc152a885d9b4d41"

# Latitude, Longitude for location
forecast_location_lat = "39.365905"
forecast_location_long = "-84.369055"

ForecastIO.configure do |configuration|
    configuration.api_key = forecast_api_key
end

#forecast = JSON.parse(ForecastIO.forecast(forecast_location_lat, forecast_location_long).to_json)
#forecast["daily"]["data"].each do |day|
    #puts Time.at(day["time"]).strftime("%B %e, %Y")
    #puts day["temperatureHigh"].round
    #puts day["icon"]
    #puts day["summary"]
    #puts "----"
#end

SCHEDULER.every '15m', :first_in => 0 do |job|
  forecast = JSON.parse(ForecastIO.forecast(forecast_location_lat, forecast_location_long).to_json)
  forecast_current_temp = forecast["currently"]["temperature"].round
  forecast_current_icon = forecast["currently"]["icon"]
  forecast_current_desc = forecast["currently"]["summary"]
  if forecast["minutely"]
    forecast_next_desc  = forecast["minutely"]["summary"]
    forecast_next_icon  = forecast["minutely"]["icon"]
  else
    puts "Did not get minutely forecast data again"
    forecast_next_desc  = "No data"
    forecast_next_icon  = ""
  end
  icons = Array.new
  forecast["daily"]["data"].each_with_index do |day, index|
    forecast["daily"]["data"][index]["index"] = index
    forecast["daily"]["data"][index]["day"] = Time.at(day["time"]).strftime("%A")
    forecast["daily"]["data"][index]["temperatureLow"] = day["temperatureLow"].round
    forecast["daily"]["data"][index]["temperatureHigh"] = day["temperatureHigh"].round
    if index > 0 && index <=3
        icons.push(day["icon"])
    else
        #forecast["daily"]["data"].delete_at[index]
    end
  end

  forecast_daily_high = forecast["daily"]["data"][0]["temperatureHigh"].round
  forecast_daily_low = forecast["daily"]["data"][0]["temperatureLow"].round
  forecast_later_desc = forecast["hourly"]["summary"]
  forecast_later_icon = forecast["hourly"]["icon"]
  send_event('forecast_detail', { items: forecast["daily"]["data"], current_temp: "#{forecast_current_temp}", current_icon: "#{forecast_current_icon}", current_desc: "#{forecast_current_desc}", next_icon: "#{forecast_next_icon}", next_desc: "#{forecast_next_desc}", later_icon: "#{forecast_later_icon}", later_desc: "#{forecast_later_desc}", daily_high: "#{forecast_daily_high}", daily_low: "#{forecast_daily_low}"})
  send_event('forecast_summary', { items: forecast["daily"]["data"], current_temp: "#{forecast_current_temp}", current_icon: "#{forecast_current_icon}", current_desc: "#{forecast_current_desc}", next_icon: "#{forecast_next_icon}", next_desc: "#{forecast_next_desc}", later_icon: "#{forecast_later_icon}", later_desc: "#{forecast_later_desc}", daily_high: "#{forecast_daily_high}", daily_low: "#{forecast_daily_low}"})
end