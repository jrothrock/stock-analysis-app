class AddColumnsToForecasts < ActiveRecord::Migration
  def change
    add_column :forecasts, :cities, :string
    add_column :forecasts, :highs, :text, array:true, default: []
    add_column :forecasts, :lows, :text, array:true, default: []
    add_column :forecasts, :averageHigh, :integer
    add_column :forecasts, :averageLow, :integer
  end
end
