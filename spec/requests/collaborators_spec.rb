require 'rails_helper'

RSpec.describe "Collaborators", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:todo_list) { create(:todo_list, user: user) }
  let!(:collaborator) { create(:collaborator, user: other_user, todo_list: todo_list) }
  let(:headers) { user.create_new_auth_token }

  describe "GET /todo_lists/:todo_list_id/collaborators" do
      it "returns a list of collaborators" do
        get "/todo_lists/#{todo_list.id}/collaborators", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(1)
        expect(json.first['id']).to eq(collaborator.id)
      end
      it "returns an error when the user is unauthorized" do
        get "/todo_lists/#{todo_list.id}/collaborators"
        expect(response).to have_http_status(:unauthorized)
        expect(json['errors']).to include('You need to sign in or sign up before continuing.')
      end
  end

  describe "POST /todo_lists/:todo_list_id/collaborators" do
    it "creates a new collaborator if the user is the owner of the todo list" do
      new_user = create(:user) # Create a new user to be added as a collaborator
      
      expect {
        post "/todo_lists/#{todo_list.id}/collaborators", 
             params: { collaborator: { user_id: new_user.id } }, 
             headers: headers
      }.to change(Collaborator, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(json['user_id']).to eq(new_user.id) # Ensure the correct collaborator is added
    end

    it "returns an error if the collaborator already exists" do
      post "/todo_lists/#{todo_list.id}/collaborators", 
           params: { collaborator: { user_id: other_user.id } }, 
           headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include("Collaborator already exists")
    end
  end

  describe "DELETE /todo_lists/:todo_list_id/collaborators/:id" do
    it "removes a collaborator from the todo list" do
      expect {
        delete "/todo_lists/#{todo_list.id}/collaborators/#{collaborator.id}", headers: headers
      }.to change(Collaborator, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(json['message']).to eq('Collaborator removed successfully')
    end

    it "returns an error if the collaborator is not found" do
      delete "/todo_lists/#{todo_list.id}/collaborators/9999", headers: headers

      expect(response).to have_http_status(:not_found)
      expect(json['error']).to eq('Collaborator not found')
    end

    it "returns an error if the user is not the owner of the todo list" do
      non_owner_user = create(:user)
      non_owner_headers = non_owner_user.create_new_auth_token

      delete "/todo_lists/#{todo_list.id}/collaborators/#{collaborator.id}", headers: non_owner_headers

      expect(response).to have_http_status(:forbidden)
      expect(json['error']).to eq("You are not authorized to perform this action")
    end
  end
end
