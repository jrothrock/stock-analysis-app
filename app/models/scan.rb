# == Schema Information
#
# Table name: scans
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  info   			:json             default: []
#  stock   			:string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#         

class Scan < ActiveRecord::Base
	belongs_to :user
	validates :user_id, presence: true
	validates :stock, presence: true
end
