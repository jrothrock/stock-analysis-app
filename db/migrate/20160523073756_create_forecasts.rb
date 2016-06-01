class CreateForecasts < ActiveRecord::Migration
  def change
    create_table :forecasts do |t|

      t.timestamps null: false
    end
  end
end
