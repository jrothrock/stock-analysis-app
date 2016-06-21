class ForecastsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'html' }
	
	def create

		# Hardcoded for simplicity, but params could be passed in with a post request - only issue with this, is that dyanmic params may not work with Wunderground's API
		#Broke all the cities up into blocks due to API restrictions - calls per a minute. 
		block1 = [['co', 'Denver'], ['Mexico', 'Mexico_City'], ['ny','New_York'], ['ca','Los_Angeles'], ['Canada', 'Toronto'], ['il', 'Chicago'], ['tx', 'Austin'], ['Cuba', 'Havana'],['or', 'Portland'], ['az','Phoenix']]
		block2 = [['ca','San_Francisco'], ['Mexico','Juarez'], ['Canada', 'Vancouver'], ['Canada', 'Winnipeg'], ['ga', 'Atlanta'], ['ma', 'Boston'], ['dc', 'Washington'], ['fl', 'Tampa'], ['mo', 'St_Louis'], ['la', 'New_Orleans']]
		block3 = [['Germany', 'Munich'], ['Turkey','Istanbul'], ['Russia','Moscow'], ['France', 'Paris'], ['UK', 'London' ], ['Russia', 'Saint_Petersburg'], ['Germany', 'Berlin'], ['Spain', 'Madrid'], ['Italy', 'Rome'], ['Ukraine', 'Kiev']]
		block4 = [['Austria', 'Vienna'], ['Belarus','Minsk'], ['Romania', 'Bucharest'], ['Hungary', 'Budapest'], ['Poland','Warsaw'], ['Serbia', 'Belgrade'], ['Italy', 'Milan'], ['Bulgaria','Sofia'], ['Ukraine', 'Odessa'], ['Russia', 'Ufa']]
		block5 = [['China','Shanghai'], ['Japan', 'Tokyo'], ['Pakistan', 'Karachi'], ['China', 'Tianjin'], ['South_Korea', 'Seoul'], ['India', 'Mumbai'], ['India', 'Delhi'], ['Philippines', 'Manila'], ['China', 'Hong_Kong'], ['Australia','Sydney']]
		block6 = [['Australia', 'Melbourne'], ['Indonesia', 'Jakarta'], ['Bangladesh', 'Dhaka'], ['Iran','Tehran'], ['Thailand','Bangkok'], ['Japan','Osaka'], ['India', 'Chennai'], ['India', 'Kolkata'], ['Malaysia','Kuala_Lumpur'], ['China', 'Shenyang']]
		

		naCities = [block1, block2]
		europeanCities = [block3, block4]
		asianCities = [block5, block6]
		blocks = [naCities, europeanCities, asianCities]
		
		
		temperatures = []
		naCitiesLow = []
    	naCitiesHigh = []
    	europeanCitiesLow = []
    	europeanCitiesHigh = []
		asianCitiesLow = []
   		asianCitiesHigh = []
    	allAverageLows = []
   		allAverageHighs = []

	   


	    wKey = ''
	    begin
		    blocks.each_with_index do |region, key|
		    	regionKey = key
		    	regionLow = []
		    	regionHigh = []
		    	region.each_with_index do |block, key|

			    	sleep 60
					block.each do |city|
						begin 
							Timeout::timeout(10) do
								@response = HTTParty.get("http://api.wunderground.com/api/#{wKey}/forecast10day/q/#{city[0]}/#{city[1]}.json", verify: false)
						    	@parsed = JSON.parse(@response.body)
						    end
					    rescue => e
					    	flash[:error] = "Could not generate report. Please try again"
            				redirect_to root_path
            				Rails.logger.info "Forecast failed on the API call"
					    end
				    	highs = []
				    	lows = []
				    	currentCity = city[1].gsub('_', ' ')
				    	
				    	7.times do |i|
					    	
					    
					    	highs << @parsed['forecast']['simpleforecast']['forecastday'][i]['high']['fahrenheit'].to_i #days high
					    	lows << @parsed['forecast']['simpleforecast']['forecastday'][i]['low']['fahrenheit'].to_i #days low

				   		end

				   		averageLow = (lows.sum / 7)
		   				averageHigh = (highs.sum / 7)
		   				allAverageLows << averageLow
		   				allAverageHighs << averageHigh
		   				regionLow << averageLow
		   				regionHigh << averageHigh

				   		temperatures << [currentCity,highs,lows,averageLow,averageHigh]
				   	

					end

				end

				puts "region completed"

				if regionKey == 0
					naCitiesLow = (regionLow.sum / regionLow.length)
					naCitiesHigh = (regionHigh.sum / regionHigh.length)
				elsif regionKey == 1
					europeanCitiesLow = (regionLow.sum / regionLow.length)
					europeanCitiesHigh = (regionHigh.sum / regionHigh.length)
				else 
					asianCitiesLow = (regionLow.sum / regionLow.length)
					asianCitiesHigh = (regionHigh.sum / regionHigh.length)
				end
			end
		rescue => e
			flash[:error] = "Something went wrong when generating the forecast"
			redirect_to root_path
			Rails.logger.info "Forecast failed somewhere in the looping"
		end

		citiesLength = block1.length + block2.length + block3.length + block4.length + block5.length + block6.length
		temperatures << naCitiesLow
		temperatures << naCitiesHigh
		temperatures << europeanCitiesLow
		temperatures << europeanCitiesHigh
		temperatures << asianCitiesLow
		temperatures << asianCitiesHigh
		temperatures << (allAverageLows.sum / citiesLength)
		temperatures << (allAverageHighs.sum / citiesLength)

		Rails.logger.info "temperatures====#{temperatures}====="

		f = Forecast.new

			if !!params[:rake]
				f.user_id = 1
			else
				f.user_id = current_user.id
			end

	   		f.temperatures = temperatures

	   
	   	if f.save

			flash[:success] = "Your report has been generated!"
			respond_to do |format|
				format.html { redirect_to root_path }
        		format.js
      		end
			
			

		else
			flash[:error] = "Something went wrong when generating the forecast"
			Rails.logger.info "Failed to save the report"
		end

	end

end
