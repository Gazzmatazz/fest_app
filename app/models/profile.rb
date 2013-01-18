# == Schema Information
#
# Table name: profiles
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  gender              :string(255)
#  relationship_status :string(255)
#  birthdate           :date
#  city                :string(255)
#  music               :string(255)
#  about_me            :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Profile < ActiveRecord::Base
  attr_accessible :about_me, :birthdate, :city, :gender, :music, :relationship_status
  
  
  belongs_to :user

  validates :user_id, presence: true

end
