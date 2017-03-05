require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:board) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:board) }
end