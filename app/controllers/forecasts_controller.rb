class ForecastsController < ApplicationController
	before_action :authenticate_user!
	def create

		# Hardcoded for simplicity, but params could be passed in with a post request - only issue with this is that dyanmic params may not work with Wunderground's API
		cities = [['co', 'Denver'], ['ca','San_Francisco'], ['il','Chicago'], ['ga', 'Atlanta'], ['tx','Dallas'], ['fl', 'Miami'], ['wa', 'Seattle'], ['ny','New_York'], ['ma', 'Boston']]
		temperatures = []
		allAverageLows = []
	    allAverageHighs = []

	    #Putting the key here instead of in the enviornment, get over it.
	    wKey = ''

		cities.each do |city|

			response = HTTParty.get("http://api.wunderground.com/api/#{wKey}/forecast10day/q/#{city[0]}/#{city[1]}.json", verify: false)
	    	parsed = JSON.parse(response.body)
	    	highs = []
	    	lows = []
	    	currentCity = city[1].gsub('_', ' ')
	    	
	    	7.times do |i|
		    	daysHigh = parsed['forecast']['simpleforecast']['forecastday'][i]['high']['fahrenheit'].to_i
		    	daysLow = parsed['forecast']['simpleforecast']['forecastday'][i]['low']['fahrenheit'].to_i
		    
		    	## Push and << are the same thing
		    	highs << daysHigh 
		    	lows << daysLow
	   		end

	   		averageLow = (lows.sum / 7)
	   		averageHigh = (highs.sum / 7)
	   		allAverageLows << averageLow
	   		allAverageHighs << averageHigh

	   		cityTemperature = [currentCity,highs,lows,averageLow,averageHigh]
	   		temperatures << cityTemperature
	   		


		end

		temperatures << (allAverageLows.sum / cities.length)
		temperatures << (allAverageHighs.sum / cities.length)
		Rails.logger.info "temperatures====#{temperatures}====="

		f = Forecast.new

	   		f.user_id = current_user.id
	   		f.temperatures = temperatures

	   
	   	if f.save

			flash[:success] = "Your report has been generated!"
			respond_to do |format|
				format.html {redirect_to root_path}
        		format.js
      		end
			

		else
			flash.now[:error] = "Something went wrong when generating the forecast"
		end
	end
end
