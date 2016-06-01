class Scan < ActiveRecord::Base
	belongs_to :user
	validates :user_id, presence: true
	validates :stock, presence: true
end
