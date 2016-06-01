class ChangeColumnsForScans < ActiveRecord::Migration
  def change
  	change_table :scans do |t|
  		t.remove :stock, :name, :bookvalue, :eps, :ebitda, :marketcap
	end
	add_column :scans, :info, :json, default: []
  end
end
