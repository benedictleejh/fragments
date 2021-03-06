# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  creator_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Story < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  
  has_many :fragments, inverse_of: :story
  has_many :authors, -> { uniq }, through: :fragments
  
  accepts_nested_attributes_for :fragments

  validates :title, presence: true, length: { minimum: 2 }
  validates :creator, presence: true
end
