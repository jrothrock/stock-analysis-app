class AddStockToScans < ActiveRecord::Migration
  def change
    add_column :scans, :stock, :string
  end
end
