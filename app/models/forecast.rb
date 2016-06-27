# == Schema Information
#
# Table name: forecasts
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  temperatures     :json             default: []
#  created_at       :datetime         not null
#  updated_at       :datetime         not null

class Forecast < ActiveRecord::Base
end