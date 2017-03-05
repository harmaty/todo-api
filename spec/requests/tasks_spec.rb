require 'rails_helper'

RSpec.describe 'Tasks API' do
  let!(:board) { create(:board) }
  let!(:tasks) do
    create_list(:task, 15, board_id: board.id)
    create_list(:task, 5, board_id: board.id, completed_at: Time.now)
  end
  let(:board_id) { board.id }
  let(:id) { tasks.first.id }

  describe 'GET /boards/:board_id/tasks' do

    context 'when board exists' do
      before { get "/boards/#{board_id}/tasks" }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all board tasks' do
        expect(json.size).to eq(20)
      end
    end

    context 'when board does not exist' do
      before { get "/boards/#{board_id}/tasks" }

      let(:board_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end
    end

    context 'when type is completed' do
      before { get "/boards/#{board_id}/tasks", type: 'completed' }

      it 'returns all board tasks' do
        expect(json.size).to eq(5)
      end
    end

    context 'when type is incomplete' do
      before { get "/boards/#{board_id}/tasks", type: 'incomplete' }

      it 'returns all board tasks' do
        expect(json.size).to eq(15)
      end
    end
  end

  describe 'GET /boards/:board_id/tasks/:id' do
    before { get "/boards/#{board_id}/tasks/#{id}" }

    context 'when board task exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the task' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when board task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  describe 'POST /boards/:board_id/tasks' do
    let(:valid_attributes) { { title: 'Visit Narnia' } }

    context 'when request attributes are valid' do
      before { post "/boards/#{board_id}/tasks", task: valid_attributes }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/boards/#{board_id}/tasks", task: { description: 'Some text' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /boards/:board_id/tasks/:id' do
    let(:valid_attributes) { { title: 'Fix a bug' } }

    before { put "/boards/#{board_id}/tasks/#{id}", task: valid_attributes }

    context 'when task exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the task' do
        updated_task = Task.find(id)
        expect(updated_task.title).to match(/Fix a bug/)
      end
    end

    context 'when the task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  describe 'PATCH /boards/:board_id/tasks/:id/complete' do
    before { patch "/boards/#{board_id}/tasks/#{id}/complete" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'completes the task' do
      completed_task = Task.find(id)
      expect(completed_task.completed_at).not_to be_nil
    end
  end

  describe 'DELETE /boards/:id' do
    before { delete "/boards/#{board_id}/tasks/#{id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end