# == Schema Information
#
# Table name: users
#
#  id 		           	  :integer          not null, primary key
#  user_name 		      :string           not null
#  email           		  :string           default: "", not null
#  encrypted_password     :string           default: "", not null
#  admin           		  :boolean          default: false, not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_sign_in_ip        :string
#  current_sign_in_ip     :string
#  sign_in_count		  :integer          default 0, null:false
#  current_sign_in_at	  :datetime
#  last_sign_in_at		  :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :dateTime
#  reset_password_token   :string
#


class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :user_name, presence: true, length: { minimum: 4, maximum: 12 }
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :validatable, password_length: 6..30

  has_many :scans
end
