class ChangeColumnsForForecast < ActiveRecord::Migration
  def change
  	change_table :forecasts do |t|
  		t.remove :cities, :highs, :lows, :averageHigh, :averageLow
	end
	add_column :forecasts, :temperatures, :text, array:true, default: []
  end
end
