require 'rails_helper'

RSpec.describe 'Dashboard API', type: :request do
  let!(:board) { create(:board) }
  let!(:tasks) do
    create_list(:task, 15, board: board)
    create_list(:task, 5, board: board, completed_at: Time.now)
  end

  describe 'GET /' do
    before { get '/' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns total boards number' do
      expect(json['total_boards']).to eq(1)
    end

    it 'returns total tasks number' do
      expect(json['total_tasks']).to eq(20)
    end

    it 'returns total incomplete tasks number' do
      expect(json['total_incomplete_tasks']).to eq(15)
    end
  end

end