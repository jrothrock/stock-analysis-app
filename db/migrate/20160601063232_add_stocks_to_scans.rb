class AddStocksToScans < ActiveRecord::Migration
  def change
    add_column :scans, :stock, :string
  end
end
