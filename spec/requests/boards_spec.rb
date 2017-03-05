require 'rails_helper'

RSpec.describe 'Boards API', type: :request do
  let!(:boards) { create_list(:board, 10) }
  let(:board_id) { boards.first.id }

  describe 'GET /boards' do
    # make HTTP get request before each example
    before { get '/boards' }

    it 'returns boards' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /boards/:id' do
    before { get "/boards/#{board_id}" }

    context 'when the record exists' do
      it 'returns the board' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(board_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:board_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end
    end
  end

  describe 'POST /boards' do
    # valid payload
    let(:valid_attributes) { { title: 'Learn Elm' } }

    context 'when the request is valid' do
      before { post '/boards', board: valid_attributes }

      it 'creates a board' do
        expect(json['title']).to eq('Learn Elm')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      # invalid payload
      before { post '/boards', board: { description: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /boards/:id' do
    let(:valid_attributes) { { title: 'Shopping' } }

    context 'when the record exists' do
      before { put "/boards/#{board_id}", board: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /boards/:id' do
    before { delete "/boards/#{board_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end