require 'timeout'

class ScansController < ApplicationController
	before_action :authenticate_user!, except: [:index, :fundamentals, :moreInfo]
  
  def moreInfo
    data = {}
    dates = []
    close_prices =[]
    open_prices=[]
    data[:stock] = params[:stock].to_s
    begin
      begin
        Timeout::timeout(5) do
          @yahoo_client ||= YahooFinance::Client.new
          @returned = @yahoo_client.historical_quotes(data[:stock], { start_date: Time::now-(24*60*60*30), end_date: Time::now }), [:trade_date, :open_price, :close_price]
        end 
        rescue Timeout::Error 
            flash[:error] = "Could not generate report. Please try again"
            redirect_to root_path
            Rails.logger.info "More info failed as it timedout"
      end
       



        #Values below are unshifted due to the way the points are plotted on the graph
        #There is probably a way to reverse the x-axis on highcharts though...
        @returned[0].length.times do |t|
          dates.unshift(@returned[0][t].trade_date)
          close_prices.unshift(@returned[0][t].close.to_f)
          open_prices.unshift(@returned[0][t].open.to_f)
        end
        
        data[:dates] = dates
        data[:close_prices] = close_prices
        data[:open_prices] = open_prices
        Rails.logger.info "data====#{data}====="
        render json: {data: data}
        rescue OpenURI::HTTPError => e
          if e.message == '404 Not Found'
            flash[:error] = "Could not generate bid/ask prices"
            Rails.logger.info "More info returned a 404"
            redirect_to root_path
          else
            raise e
          end
    end
    
  end


  def fundamentals
    respond_to do |format|
      format.js
    end
  end

 

	def index


############# FOR SCANS ####################   
  		@scans = Scan.order('created_at DESC').paginate(page: params[:page], per_page: 15)

      @temps = Forecast.last

##############FOR FORECASTS ##################



       ##There HAS to be a better way of doing this...

      if !!@temps
        @Denver = @temps['temperatures'][0]
        @Mexico_City = @temps['temperatures'][1]
        @New_York = @temps['temperatures'][2]
        @Los_Angeles = @temps['temperatures'][3]
        @Toronto = @temps['temperatures'][4]
        @Chicago = @temps['temperatures'][5]
        @Austin = @temps['temperatures'][6]
        @Havana = @temps['temperatures'][7]
        @Portland = @temps['temperatures'][8]
        @Phoenix = @temps['temperatures'][9]
        @San_Francisco = @temps['temperatures'][10]
        @Juarez = @temps['temperatures'][11]
        @Vancouver = @temps['temperatures'][12]
        @Winnipeg = @temps['temperatures'][13]
        @Atlanta = @temps['temperatures'][14]
        @Boston = @temps['temperatures'][15]
        @Washington = @temps['temperatures'][16]
        @Tampa = @temps['temperatures'][17]
        @St_Louis = @temps['temperatures'][18]
        @New_Orleans = @temps['temperatures'][19]
        @Munich = @temps['temperatures'][20]
        @Istanbul = @temps['temperatures'][21]
        @Moscow = @temps['temperatures'][22]
        @Paris = @temps['temperatures'][23]
        @London = @temps['temperatures'][24]
        @Saint_Petersburg = @temps['temperatures'][25]
        @Berlin = @temps['temperatures'][26]
        @Madrid = @temps['temperatures'][27]
        @Rome = @temps['temperatures'][28]
        @Kiev = @temps['temperatures'][29]
        @Vienna = @temps['temperatures'][30]
        @Minsk = @temps['temperatures'][31]
        @Bucharest = @temps['temperatures'][32]
        @Budapest = @temps['temperatures'][33]
        @Warsaw = @temps['temperatures'][34]
        @Belgrade = @temps['temperatures'][35]
        @Milan = @temps['temperatures'][36]
        @Sofia = @temps['temperatures'][37]
        @Odessa = @temps['temperatures'][38]
        @Ufa = @temps['temperatures'][39]
        @Shanghai = @temps['temperatures'][40]
        @Tokyo = @temps['temperatures'][41]
        @Karachi = @temps['temperatures'][42]
        @Tianjin = @temps['temperatures'][43]
        @Seoul = @temps['temperatures'][44]
        @Mumbai = @temps['temperatures'][45]
        @Delhi = @temps['temperatures'][46]
        @Manila = @temps['temperatures'][47]
        @Hong_Kong = @temps['temperatures'][48]
        @Sydney = @temps['temperatures'][49]
        @Melbourne = @temps['temperatures'][50]
        @Jakarta = @temps['temperatures'][51]
        @Dhaka = @temps['temperatures'][52]
        @Tehran = @temps['temperatures'][53]
        @Bangkok = @temps['temperatures'][54]
        @Osaka = @temps['temperatures'][55]
        @Chennai = @temps['temperatures'][56]
        @Kolkata = @temps['temperatures'][57]
        @Kuala_Lumpur = @temps['temperatures'][58]
        @Shenyang = @temps['temperatures'][59]
        @naCitiesLow = @temps['temperatures'][60]
        @naCitiesHigh = @temps['temperatures'][61]
        @europeanCitiesLow = @temps['temperatures'][62]
        @europeanCitiesHigh = @temps['temperatures'][63]
        @asianCitiesLow = @temps['temperatures'][64]
        @asianCitiesHigh = @temps['temperatures'][65]
        @allAverageLows = @temps['temperatures'][66]
        @allAverageHighs = @temps['temperatures'][67]
      end

      @cities = [@Denver, @Mexico_City, @New_York, @Los_Angeles, @Toronto, @Chicago, @Austin, @Havana, @Portland, @Phoenix, @San_Francisco, @Juarez, @Vancouver, @Winnipeg, @Atlanta, @Boston, @Washington, @Tampa, @St_Louis, @New_Orleans, @Munich, @Istanbul, @Moscow, @Paris, @London, @Saint_Petersburg, @Berlin, @Madrid, @Rome, @Kiev, @Vienna, @Minsk,  @Bucharest, @Budapest, @Warsaw, @Belgrade, @Milan, @Sofia, @Odessa, @Ufa, @Shanghai, @Tokyo, @Karachi, @Tianjin, @Seoul, @Mumbai, @Delhi, @Manila, @Hong_Kong, @Sydney, @Melbourne, @Jakarta, @Dhaka, @Tehran, @Bangkok, @Osaka, @Chennai, @Kolkata, @Kuala_Lumpur, @Shenyang]

      #This is a lot of db queries, and calculations, with the majority of it being pointless ish. May want to make a new table for this.
      #Another possibility is to create a seperate column in forecast and set it to null if Forecast.all.length is less than 7.
      #This also ONLY works if there is a cronjob pulling the data daily.

      forecastLength = Forecast.all.length
      @fcl = false
      if forecastLength > 6
        @fcl = true
        weeklyForecastID = @temps.id.to_i - 6
        data = Forecast.where(id: weeklyForecastID .. Forecast.last.id).order('created_at').to_a

        @projectedNAHigh = data[0]['temperatures'][61].to_i
        @projectNALow = data[0]['temperatures'][60].to_i
        @projectedEUROHigh = data[0]['temperatures'][63].to_i
        @projectedEUROLow = data[0]['temperatures'][62].to_i
        @projectedASIANHigh = data[0]['temperatures'][65].to_i
        @porjectedASIANLow = data[0]['temperatures'][64].to_i
        @projectedGlobalHigh = data[0]['temperatures'][67].to_i
        @projectedGlobalLow = data[0]['temperatures'][66].to_i
        @projectionsNA = [@projectedNAHigh, @projectNALow]
        @projectionsEU = [@projectedEUROHigh, @projectedEUROLow]
        @projectionsASIA = [@projectedASIANHigh, @porjectedASIANLow]
        @projectionsGlobal = [@projectedGlobalHigh, @projectedGlobalLow]

        currentNHighs = []
        currentNLows = []
        currentEHighs = []
        currentELows = []
        currentAHighs = []
        currentALows = []
        currentGHighs = []
        currentGLows = []


        #GET North American Averages

        data.length.times do |i|
          20.times do |c|
            currentNHighs << data[i]['temperatures'][c][1][0].to_i
            currentNLows << data[i]['temperatures'][c][2][0].to_i
          end
        end
       

        #GET European Averages
        data.length.times do |i|
          20.times do |c|
            eutimes = c + 20
            currentEHighs << data[i]['temperatures'][eutimes][1][0].to_i
            currentELows << data[i]['temperatures'][eutimes][2][0].to_i
          end
        end

        #GET Asian Averages
        data.length.times do |i|
          20.times do |c|
            asiantimes = c + 40
            currentAHighs << data[i]['temperatures'][asiantimes][1][0].to_i
            currentALows << data[i]['temperatures'][asiantimes][2][0].to_i
          end
        end


        #GET Global Averages
        data.length.times do |i|
          @cities.length.times do |c|
            currentGHighs << data[i]['temperatures'][c][1][0].to_i
            currentGLows << data[i]['temperatures'][c][2][0].to_i
          end
        end

        @actualNHigh = ((currentNHighs.sum / data.length) / 20)
        @actualNLow = ((currentNLows.sum / data.length) / 20)
        @actualEHigh = ((currentEHighs.sum / data.length) / 20)
        @actualELow = ((currentELows.sum / data.length) / 20)
        @actualAHigh = ((currentAHighs.sum / data.length) / 20)
        @actualALow = ((currentALows.sum / data.length) / 20)
        @actualGHigh = ((currentGHighs.sum / data.length) / @cities.length)
        @actualGLow = ((currentGLows.sum / data.length) / @cities.length)

        @actualsNA = [@actualNHigh, @actualNLow]
        @actualsEU = [@actualEHigh, @actualELow]
        @actualsASIA = [@actualAHigh, @actualALow]
        @actualsGlobal = [@actualGHigh, @actualGLow]

      end

      respond_to do |format|
        format.js 
        format.html
      end
  end

	def new

		@scan = current_user.scans.build

	end

	def create
  
    stockTicker = params[:scan][:stock].upcase
  
    response = HTTParty.get("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22#{stockTicker}%22)%0A%09%09&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json", verify: false)
    
    parsed = JSON.parse(response.body)
    Rails.logger.info "parsed====#{parsed}====="
  
    if !!parsed['query']['results'] && !!parsed['query']['results']['quote']['BookValue']
    
        info = []

        info << parsed['query']['results']['quote']['Name']
        info << stockTicker
        info << parsed['query']['results']['quote']['Ask']
        info << parsed['query']['results']['quote']['Change_PercentChange']
        info << parsed['query']['results']['quote']['BookValue']
        info << parsed['query']['results']['quote']['PriceBook']
        info << parsed['query']['results']['quote']['EarningsShare']
        info << parsed['query']['results']['quote']['EPSEstimateNextQuarter']
        info << parsed['query']['results']['quote']['EBITDA']
        info << parsed['query']['results']['quote']['MarketCapitalization']
        info << parsed['query']['results']['quote']['AverageDailyVolume']

        s = Scan.new
        
        s.user_id = current_user.id
        s.stock = stockTicker
        s.info = info

        if s.save
          flash[:success] = "Your report has been generated!"
          redirect_to root_path
        else
          flash.now[:error] = "Something went wrong when generating your report, please try again."
          render :new
        end
    else

      flash.now[:error] = "Your new scan couldn't be created! Please make sure you entered a valid ticker."
      render :new

    end
    
	end

	def update
		if @scan.update(site_params)
    		flash[:success] = "Site updated."
    		respond_to do |format|
        		format.html { redirect_to root_path }
        		format.js
      		end
    	else
    		flash[:alert] = "Update failed.  Please check the form."
    		render :edit
    	end
	end

	def destroy
		@scan.destroy
  		flash[:success] = "Your site has been deleted"
  		respond_to do |format|
        	format.html { redirect_to root_path }
        	format.js
      end
	end

	private

  def set_scan
    @scan = Scan.find(params[:id])
  end

	def scan_params
    	params.require(:scan).permit(:stock, :name, :bookvalue, :eps, :ebitda, :marketcap)
  end

end

	