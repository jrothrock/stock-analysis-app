namespace :forecast do
desc "do a forecast"
	task :generate => :environment do
	   	HTTParty.post("http://localhost:3000/forecasts", 
    	:body => {"utf8"=>"✓", "rake"=>"yup", "commit"=>"New Report"},
    	:headers => { 'X-Requested-With' => 'XMLHttpRequest',
    	'User-Agent' => 'Mozilla/5.0 (iPhone; U; ru; CPU iPhone OS 4_2_1 like Mac OS X; ru) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148a Safari/6533.18.5',
    	'ContentType' => 'HTML' })
	end
end