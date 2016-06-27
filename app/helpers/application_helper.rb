module ApplicationHelper

	def alert_for(flash_type)
		case flash_type
		when "success" then 1
		when "alert" then 2
		when "error" then 3
		when "notice" then 4
		else 1
		end
	end

	def dateFormat(current, adjust)
		return (current + adjust.days)
	end


	def checkPredictionLow(projectionsLow, actualsLow)
		case 
		when projectionsLow < actualsLow
			then " While last weeks, average, low (#{actualsLow})  was higher than projected (#{projectionsLow})."
		when projectionsLow > actualsLow
			then " While last weeks, average, low (#{actualsLow}) was lower than projected (#{projectionsLow})."
		else 
			" While last weeks, average, low (#{projectionsLow}) was the same as was projected (#{actualsLow})."
		end	
	end

	def checkPredictionHigh(projectionsHigh, actualsHigh, region)
		case 
		when projectionsHigh < actualsHigh
			then "Last weeks, average, high (#{actualsHigh}) in #{region} was higher than projected (#{projectionsHigh})."
		when projectionsHigh > actualsHigh
			then "Last weeks, average, high (#{actualsHigh}) in #{region} was lower than projected (#{projectionsHigh})."
		else
			"Last weeks, average, high (#{actualsHigh}) in #{region} was the same as was projected (#{projectionsHigh})."
		end
	end

	def checkPrediction(projections, actuals, region)
		return checkPredictionHigh(projections[0],actuals[0], region) + checkPredictionLow(projections[1], actuals[1])
	end


	def checkLength
		accrued = (((Time.now - Forecast.first.created_at).to_i / 60) / 60) /24 
		time =  7 - accrued
		case 
		when time == 1 then "#{accrued} days of data has accrued, please check back tomorrow."
		when time == 7 then "Data just started accruing today, please check back in a week."
		when time == 6 then "Data just started accruing yesterday, please check back in #{time} days."
		else "#{accrued} days of data has accrued, please check back in #{time} days."
		end
	end

end