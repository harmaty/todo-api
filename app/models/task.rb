# == Schema Information
#
# Table name: tasks
#
#  id           :integer          not null, primary key
#  title        :string
#  description  :text
#  board_id     :integer
#  completed_at :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

class Task < ActiveRecord::Base

  belongs_to :board

  validates_presence_of :title, :board

  scope :completed, -> { where.not(completed_at: nil) }
  scope :incomplete, -> { where(completed_at: nil) }

  def complete!
    update_attribute :completed_at, Time.now
  end
end
