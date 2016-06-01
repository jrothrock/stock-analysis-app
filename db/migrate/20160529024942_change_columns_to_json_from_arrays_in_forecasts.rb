class ChangeColumnsToJsonFromArraysInForecasts < ActiveRecord::Migration
  def change
  	remove_column :forecasts, :temperatures, :text, array:true, default: []
    add_column :forecasts, :temperatures, :json, default: []
  end
end
