require 'rails_helper'

RSpec.describe "Todos API", type: :request do
  # Create test data
  let!(:todos) { create_list(:todo, 5) }
  let(:todo_id) { todos.first.id }

  # Index
  describe "GET /todos" do
    it "returns all todos" do
      get '/todos'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(5)
    end
  end

  # Create
  describe "POST /todos" do
    let(:valid_attributes) { { todo: { title: 'New Todo', completed: false } } }

    context "when the request is valid" do
      it "creates a new todo" do
        post '/todos', params: valid_attributes

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('New Todo')
      end
    end

    context "when the request is invalid" do
      it "returns a validation error" do
        post '/todos', params: { todo: { completed: false } } # Missing title

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Title can't be blank")
      end
    end
  end

  # Update
  describe "PUT /todos/:id" do
    let(:valid_attributes) { { completed: true } }

    context "when the record exists" do
      it "updates the todo" do
        put "/todos/#{todo_id}", params: valid_attributes

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['completed']).to eq(true)
      end
    end
  end

  # Destroy
  describe "DELETE /todos/:id" do
    context "when the record exists" do
      it "deletes the todo" do
        delete "/todos/#{todo_id}"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Todo deleted successfully')
      end
    end
  end
end
