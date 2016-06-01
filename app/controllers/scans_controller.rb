class ScansController < ApplicationController
	before_action :authenticate_user!, except: [:index, :fundamentals, :moreInfo]

  def moreInfo
    data = {}
    dates = []
    close_prices =[]
    open_prices=[]
    data[:stock] = params[:stock].to_s
    @yahoo_client ||= YahooFinance::Client.new
    returned = @yahoo_client.historical_quotes(data[:stock], { start_date: Time::now-(24*60*60*30), end_date: Time::now }), [:trade_date, :open_price, :close_price]
   
    #Values below are unshifted due to the way the points are plotted on the graph
    #There is probably a way to reverse the x-axis on highcharts though...
    returned[0].length.times do |t|
      dates.unshift(returned[0][t].trade_date)
      close_prices.unshift(returned[0][t].close.to_f)
      open_prices.unshift(returned[0][t].open.to_f)
    end
    
    data[:dates] = dates
    data[:close_prices] = close_prices
    data[:open_prices] = open_prices
    Rails.logger.info "data====#{data}====="
    render json: {data: data}
  end

  def fundamentals
    respond_to do |format|
      format.js
    end
  end

 

	def index


      ##FOR SCANS   
  		@scans = Scan.limit(10).order('created_at DESC')
      @temps = Forecast.last

      ##FOR FORECASTS
      @denver = @temps['temperatures'][0]
      @san_francisco = @temps['temperatures'][1]
      @chicago = @temps['temperatures'][2]
      @atlanta = @temps['temperatures'][3]
      @dallas = @temps['temperatures'][4]
      @miami = @temps['temperatures'][5]
      @seattle = @temps['temperatures'][6]
      @new_york = @temps['temperatures'][7]
      @boston = @temps['temperatures'][8]
      @averageLow = @temps['temperatures'][9]
      @averageHigh = @temps['temperatures'][10]
      @cities = [@san_francisco, @denver, @atlanta, @dallas, @chicago, @miami, @seattle, @new_york, @boston]

      #This is a lot of db queries, with the majority of it being pointless ish. May want to make a new table for this.
      #Another possibility is to create a seperate column in forecast and set it to null if Forecast.all.length is less than 7.
      #This also ONLY works if there is a cronjob pulling the data daily.

      forecastLength = Forecast.all.length
      @fcl = false
      if forecastLength > 6
        @fcl = true
        weeklyForecastID = @temps.id.to_i - 1
        @schema = Forecast.where(id: weeklyForecastID .. forecastLength).order('created_at').to_a
        @projectedHigh = @schema[0]['temperatures'][10].to_i
        @projectedLow = @schema[0]['temperatures'][9].to_i
        @projections = [@projectedHigh, @projectedLow]

        currentHighs = []
        currentLows = []

        @schema.length.times do |i|
          @cities.length.times do |c|
            currentHighs << @schema[i]['temperatures'][c][1][0].to_i
            currentLows << @schema[i]['temperatures'][c][2][0].to_i
          end
        end

        @acutalHigh = ((currentHighs.sum / @schema.length) / @cities.length)
        @actualLow = ((currentLows.sum / @schema.length) / @cities.length)
        @actuals = [@acutalHigh, @actualLow]
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
  
    if parsed['query']['results']['quote']['BookValue'] != nil

      s = Scan.new
      
      s.user_id = current_user.id
      s.stock = stockTicker
      s.name = parsed['query']['results']['quote']['Name']
      s.bookvalue = parsed['query']['results']['quote']['BookValue']
      s.eps = parsed['query']['results']['quote']['EarningsShare']
      s.ebitda = parsed['query']['results']['quote']['EBITDA']
      s.marketcap = parsed['query']['results']['quote']['MarketCapitalization']
      if s.save
        flash[:success] = "Your report has been generated!"
        redirect_to root_path
      else
        flash[:alert] = "Something went wrong when generating your report, please try again."
        render :new
      end

    else

      flash.now[:alert] = "Your new scan couldn't be created! Please make sure you entered a valid ticker."
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

	def scan_params
    	params.require(:scan).permit(:stock, :name, :bookvalue, :eps, :ebitda, :marketcap)
  end

end

	