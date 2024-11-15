require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  let!(:todo) { Todo.create(title: 'Sample Test', completed: false) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Todo.count)
    end
  end

  describe 'GET #show' do
    context 'when the todo exists' do
      it 'returns the todo' do
        get :show, params: { id: todo.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(todo.id)
      end
    end

    context 'when the todo does not exist' do
      it 'returns a 404 status' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Todo not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new todo' do
        expect {
          post :create, params: { todos: [{ title: 'New Todo', completed: false }] }
        }.to change(Todo, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body).first['title']).to eq('New Todo')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new todo and returns errors' do
        post :create, params: { todos: [{ title: '' }] }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    context 'when the todo exists' do
      it 'updates the todo' do
        put :update, params: { id: todo.id, completed: true }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['completed']).to eq(true)
      end
    end

    context 'when the todo does not exist' do
      it 'returns a 404 status' do
        put :update, params: { id: 999, completed: true }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Todo not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the todo exists' do
      it 'deletes the todo' do
        expect {
          delete :destroy, params: { id: todo.id }
        }.to change(Todo, :count).by(-1)
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Todo deleted successfully')
      end
    end

    context 'when the todo does not exist' do
      it 'returns a 404 status' do
        delete :destroy, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Todo not found or failed to delete')
      end
    end
  end
end
