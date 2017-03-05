# == Schema Information
#
# Table name: boards
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Board < ActiveRecord::Base

  validates_presence_of :title

  has_many :tasks, dependent: :destroy
end
