require 'rails_helper'

RSpec.describe "TodoLists", type: :request do
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let!(:todo_lists) { create_list(:todo_list, 3, user: user) }

  describe "GET /todo_lists" do
    it "returns the user's todo lists" do
      get '/todo_lists', headers: headers

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end
  end

  describe "POST /todo_lists" do
    it "creates a new todo list" do
      expect {
      post '/todo_lists', 
           params: { todo_list: { title: 'New List' } }, 
           headers: headers
    }.to change(TodoList, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json['title']).to eq('New List')
    end

    it "returns an error if title is missing" do
      expect {
      post '/todo_lists', 
           params: { todo_list: { title: nil } }, 
           headers: headers
    }.not_to change(TodoList, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include("Title can't be blank")
    end
  end

  describe "GET /todo_lists/:id" do
  let(:todo_list) { create(:todo_list, user: user) }

    it "returns the todo list when found" do
      get "/todo_lists/#{todo_list.id}", params: {id: todo_list.id}, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(todo_list.id)
    end
    
    it "returns the 404 error when not found" do
      get "/todo_lists/9999", headers: headers
      expect(response).to have_http_status(:not_found)
      expect(json["error"]).to eq("Todo list not found")
    end    
  end

  describe "PATCH/PUT /todo_lists/:id" do
  let(:valid_params) { { title: "Updated Title" } }
  let(:invalid_params) { { title: "" } }
  let(:todo_list) { create(:todo_list, user: user) }

  it "updates the todo list with valid parameters" do
    put "/todo_lists/#{todo_list.id}",
        params: { todo_list: valid_params },
        headers: headers
    expect(response).to have_http_status(:ok)
    expect(todo_list.reload.title).to eq("Updated Title")
  end

  it "returns errors with invalid parameters" do
    put "/todo_lists/#{todo_list.id}",
        params: { todo_list: invalid_params },
        headers: headers
    expect(response).to have_http_status(:unprocessable_entity)
    expect(json['errors']).to include("Title can't be blank")
  end
end

  describe "DELETE /todo_lists/:id" do
    it "deletes a todo list" do
      todo_list = todo_lists.first

      expect {
      delete "/todo_lists/#{todo_list.id}", headers: headers
    }.to change(TodoList, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq('Todo list deleted sucessfully')
    end

    it "returns an error if todo list does not exist" do
      expect {
      delete "/todo_lists/0", headers: headers
    }.not_to change(TodoList, :count)

      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq('Todo list not found')
    end
  end
end
