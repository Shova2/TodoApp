require 'rails_helper'

RSpec.describe "Todos API", type: :request do
  let(:user) { create(:user) }
  let(:todo_list) { create(:todo_list, user: user) }
  let(:headers) { user.create_new_auth_token }
  let!(:todos) { create_list(:todo, 5, todo_list: todo_list) }
  let(:todo_id) { todos.first.id }

  # Index
  describe "GET /todo_lists/:todo_list_id/todos" do
    it "returns all todos" do
      get "/todo_lists/#{todo_list.id}/todos", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(5)
    end
  end

  # Create
describe "POST /todo_list/:todo_list_id/todos" do
  let(:valid_attributes) { { title: "New Todo", status: "pending" } }
  let(:invalid_attributes) { { title: "", status: "" } }

  context "with valid attributes" do
    it "creates a new todo" do
      post todo_list_todos_path(todo_list_id: todo_list.id), 
           params: { todo: valid_attributes }, headers: headers
      expect(response).to have_http_status(:created)
      expect(json['title']).to eq(valid_attributes[:title])
    end
  end

  context "with invalid attributes" do
    it "returns an error" do
      post todo_list_todos_path(todo_list_id: todo_list.id), 
           params: { todo: invalid_attributes }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include("Title can't be blank")
    end
  end
end

# show
describe "GET /todo_lists/:todo_list_id/todo/:id" do
   context"when the todo exists" do
    it "returns the todo" do
      get todo_list_todo_path(todo_list_id: todo_list.id, id: todo_id), headers: headers

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(todo_id)
    end
  end
  context "when the todo does not exist" do
    it "returns a not found error" do
      get todo_list_todo_path( todo_list.id, id: 0), headers: headers
      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq("Todo not found")
    end
  end
end

# Update
 describe "PUT /todo_list/:todo_list_id/todos/:id" do
  let!(:todo) { create(:todo, todo_list: todo_list, title: "Old Title", status: "pending") }
  let(:valid_update) { { title: "Updated Title", status: "completed" } }
  let(:invalid_update) { { title: "", status: "" } }

  context "with valid attributes" do
    it "updates the todo" do
      put todo_list_todo_path(todo_list_id: todo_list.id, id: todo.id), 
          params: { todo: valid_update }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json['title']).to eq(valid_update[:title])
      expect(json['status']).to eq(valid_update[:status])
    end
  end

  context "with invalid attributes" do
    it "returns an error" do
      put todo_list_todo_path(todo_list_id: todo_list.id, id: todo.id), 
          params: { todo: invalid_update }, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include("Title can't be blank")
    end
  end

  context "when todo is not found" do
    it "returns a not found error" do
      put todo_list_todo_path(todo_list_id: todo_list.id, id: 0), 
          params: { todo: valid_update }, headers: headers

      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq("Todo not found")
      end
    end
  end

  # Destroy
  describe "DELETE /todo_lists/:todo_list_id/todos/:id" do
    context "when the record exists" do
      it "deletes the todo" do
        delete "/todo_lists/#{todo_list.id}/todos/#{todo_id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(json[:message]).to eq('Todo deleted successfully')
      end
    end
  end
end
