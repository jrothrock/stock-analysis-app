class AddUserIdToForecasts < ActiveRecord::Migration
  def change
    add_reference :forecasts, :user, index: true, foreign_key: true
  end
end
