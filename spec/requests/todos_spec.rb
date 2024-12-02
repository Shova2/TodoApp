require 'rails_helper'

RSpec.describe "Todos API", type: :request do
  let(:user) { create(:user) }
  let(:todo_list) { create(:todo_list, user: user) }
  let(:headers) { user.create_new_auth_token }
  let!(:todos) { create_list(:todo, 5, todo_list: todo_list) }
  let(:todo_id) { todos.first.id }

  # Index
  describe "GET /todo_lists/:todo_list_id/todos" do
    context "when the user is the owner"do
    it "returns all todos" do
      get "/todo_lists/#{todo_list.id}/todos", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(5)
      end
    end

    context "when the user is a collaborator" do
      let(:collaborator) { create(:user) }
      before { create(:collaborator, user: collaborator, todo_list: todo_list) }
      let(:collaborator_headers) { collaborator.create_new_auth_token }  

      it "returns all the todos" do 
        get "/todo_lists/#{todo_list.id}/todos", headers: collaborator_headers

        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(5)
      end 
    end

    context "when the user is neither the owner nor a collaborator" do
      let(:non_member_user) { create(:user) }
      let(:non_member_headers) { non_member_user.create_new_auth_token } 
      
      it "returns no todos" do
        get "/todo_lists/#{todo_list.id}/todos", headers: non_member_headers

        expect(response).to have_http_status(:not_found)
      end 
    end
  end
  # Create
  describe "POST /todo_lists/:todo_list_id/todos" do
    let(:valid_attributes) { { title: "New Todo", status: "pending" } }
    let(:invalid_attributes) { { title: "", status: "" } }

    context "when the user is the owner" do
      it "creates a new todo" do
        post "/todo_lists/#{todo_list.id}/todos", 
            params: { todo: valid_attributes }, headers: headers

        expect(response).to have_http_status(:created)
        expect(json['title']).to eq(valid_attributes[:title])
      end
    end

    context "when the user is a collaborator" do
      let(:collaborator) { create(:user) }
      before { create(:collaborator, user: collaborator, todo_list: todo_list) }
      let(:collaborator_headers) { collaborator.create_new_auth_token }

      it "creates a new todo" do
        post "/todo_lists/#{todo_list.id}/todos", 
            params: { todo: valid_attributes }, headers: collaborator_headers

        expect(response).to have_http_status(:created)
        expect(json['title']).to eq(valid_attributes[:title])
      end
    end

    context "when the user is neither the owner nor a collaborator" do
      let(:non_member_user) { create(:user) }
      let(:non_member_headers) { non_member_user.create_new_auth_token }

      it "returns a forbidden error" do
        post "/todo_lists/#{todo_list.id}/todos", 
            params: { todo: valid_attributes }, headers: non_member_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # Show
  describe "GET /todo_lists/:todo_list_id/todos/:id" do
    context "when the todo exists" do
      it "returns the todo" do
        get "/todo_lists/#{todo_list.id}/todos/#{todo_id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['id']).to eq(todo_id)
      end
    end

    context "when the todo does not exist" do
      it "returns a not found error" do
        get "/todo_lists/#{todo_list.id}/todos/0", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq("Todo not found")
      end
    end
  end

  # Update
  describe "PUT /todo_lists/:todo_list_id/todos/:id" do
    let!(:todo) { create(:todo, todo_list: todo_list, title: "Old Title", status: "pending") }
    let(:valid_update) { { title: "Updated Title", status: "completed" } }
    let(:invalid_update) { { title: "", status: "" } }

    context "when the user is the owner" do
      it "updates the todo" do
        put "/todo_lists/#{todo_list.id}/todos/#{todo.id}", 
            params: { todo: valid_update }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['title']).to eq(valid_update[:title])
      end
    end

    context "when the user is a collaborator" do
      let(:collaborator) { create(:user) }
      before { create(:collaborator, user: collaborator, todo_list: todo_list) }
      let(:collaborator_headers) { collaborator.create_new_auth_token }

      it "updates the todo" do
        put "/todo_lists/#{todo_list.id}/todos/#{todo.id}", 
            params: { todo: valid_update }, headers: collaborator_headers

        expect(response).to have_http_status(:ok)
        expect(json['title']).to eq(valid_update[:title])
      end
    end

    context "when the user is neither the owner nor a collaborator" do
      let(:non_member_user) { create(:user) }
      let(:non_member_headers) { non_member_user.create_new_auth_token }

      it "returns a forbidden error" do
        put "/todo_lists/#{todo_list.id}/todos/#{todo.id}", 
            params: { todo: valid_update }, headers: non_member_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  # Destroy
  describe "DELETE /todo_lists/:todo_list_id/todos/:id" do
    context "when the user is the owner" do
      it "deletes the todo" do
        delete "/todo_lists/#{todo_list.id}/todos/#{todo_id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json['message']).to eq('Todo deleted successfully')
      end
    end

    context "when the user is a collaborator" do
      let(:collaborator) { create(:user) }
      before { create(:collaborator, user: collaborator, todo_list: todo_list) }
      let(:collaborator_headers) { collaborator.create_new_auth_token }

      it "returns a forbidden error" do
        delete "/todo_lists/#{todo_list.id}/todos/#{todo_id}", headers: collaborator_headers

        expect(response).to have_http_status(:forbidden)
        expect(json['error']).to eq('You are not authorized to perform this action')
      end
    end
  end
end
