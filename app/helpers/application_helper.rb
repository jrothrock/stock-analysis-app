module ApplicationHelper
	def alert_for(flash_type)
		case flash_type
		when "success" 
			1
		when "error"
			3
		when "alert"
			2
		when "notice"
			4
		end
	end

	def dateFormat(current, adjust)
		return (current + adjust.days)
	end

	##THIS IS REALLY, REALLY, BAD CODE. Thought about a case statement - can't remember if ruby has fall through, though.
	##Another idea is to have loops for the highs and lows - returning the result of the conditionals. Then concatinating the results into one string, and returning that single string. 

	def checkPrediction(projections, actuals, region)
		if projections[0] < actuals[0] && projections[1] < actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was higher than projected (#{projections[0]}), also last weeks, average, low (#{actuals[1]}) in #{region} was higher than projected (#{projections[1]})."

		elsif projections[0] > actuals[0] && projections[1] < actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was lower than projected (#{projections[0]}), but last weeks, average, low (#{actuals[1]}) in #{region} was higher than projected (#{projections[1]})."

		elsif projections[0] < actuals[0] && projections[1] > actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was higher than projected (#{projections[0]}), but last weeks, average, low (#{actuals[1]}) in #{region} was lower than projected (#{projections[1]})."
		
		elsif projections[0] > actuals[0] && projections[1] > actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was lower than projected (#{projections[0]}), and last weeks, average, low (#{actuals[1]}) in #{region} was lower than projected (#{projections[1]})."
		
		elsif projections[0] == actuals[0] && projections[1] < actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was the same as was projected (#{projections[0]}), and last weeks, average, low (#{actuals[1]}) in #{region} was higher than projected (#{projections[1]})."
		
		elsif projections[0] == actuals[0] && projections[1] > actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was the same as was projected (#{projections[0]}), and last weeks, average, low (#{actuals[1]}) in #{region} was lower than projected (#{projections[1]})."
		
		elsif projections[0] > actuals[0] && projections[1] == actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was lower than projected (#{projections[0]}), and last weeks, average, low (#{actuals[1]}) in #{region} was the same as was projected (#{projections[1]})."
		
		elsif projections[0] < actuals[0] && projections[1] == actuals[1]
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was higher than projected (#{projections[0]}), and last weeks, average, low (#{actuals[1]}) in #{region} was the same as was projected (#{projections[1]})."
		
		else
			return "Last weeks, average, high (#{actuals[0]}) in #{region} was the same as was projected (#{projections[0]}), and last weeks, average, low (#{actuals[1]}) in #{region} was the same as was projected (#{projections[1]})."
		end
	end

	def checkLength
		accrued = (((Time.now - Forecast.first.created_at).to_i / 60) / 60) /24 
		time =  7 - accrued
		if time == 1
			return "#{accrued} days of data has accrued, please check back tomorrow."
		elsif time == 7
			return "Data just started accruing today, please check back in a week."			 
		end
		return "Only #{accrued} days of data has accrued, please check back in #{time} days."
	end

	
end
