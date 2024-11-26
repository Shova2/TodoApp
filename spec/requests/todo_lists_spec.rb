require 'rails_helper'

RSpec.describe "TodoLists", type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let!(:todo_lists) { create_list(:todo_list, 3, user: user) }

  describe "GET /todo_lists" do
    it "returns the user's todo lists" do
      get '/todo_lists', headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /todo_lists" do
    it "creates a new todo list" do
      post '/todo_lists', 
           params: { todo_list: { title: 'New List' } }, 
           headers: headers

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['title']).to eq('New List')
    end

    it "returns an error if title is missing" do
      post '/todo_lists', 
           params: { todo_list: { title: nil } }, 
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
    end
  end

  describe "DELETE /todo_lists/:id" do
    it "deletes a todo list" do
      todo_list = todo_lists.first

      delete "/todo_lists/#{todo_list.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Todo list deleted sucessfully')
    end

    it "returns an error if todo list does not exist" do
      delete "/todo_lists/0", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Todo list not found')
    end
  end
end
