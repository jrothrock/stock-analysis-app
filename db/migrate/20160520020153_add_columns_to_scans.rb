class AddColumnsToScans < ActiveRecord::Migration
  def change
    add_column :scans, :name, :string
    add_column :scans, :bookvalue, :string
    add_column :scans, :eps, :string
    add_column :scans, :ebitda, :string
    add_column :scans, :marketcap, :string
  end
end
