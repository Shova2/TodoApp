class CollaboratorsController < ApplicationController
    # before_action :authenticate_user!
    before_action :set_todo_list, only: [:create, :index]
    before_action :set_collaborator, only: [:destroy]

    # GET /todo_lists/:todo_list_id/collaborators
    def index
      @collaborators = @todo_list.collaborators.includes(:user) 
      render json: @collaborators, status: :ok
    end
  
    # POST /todo_lists/:todo_list_id/collaborators
    def create
      collaborator = @todo_list.collaborators.build(collaborator_params)
      authorize collaborator  

      if collaborator.save
        render json: collaborator, status: :created
      else
        render json: { errors: collaborator.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /todo_lists/:todo_list_id/collaborators/:id
    def destroy
      @collaborator = Collaborator.find_by(id: params[:id])
      
      if @collaborator
        authorize @collaborator 
    
        if @collaborator.destroy
          render json: { message: 'Collaborator removed successfully' }, status: :ok
        else
          render json: { errors: @collaborator.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Collaborator not found' }, status: :not_found
      end
    end
    
  
  private
  def set_todo_list
    @todo_list = TodoList.find_by(id: params[:todo_list_id])
  end

  def set_collaborator
    @collaborator = Collaborator.find_by(id: params[:id])
  end

  def collaborator_params
    params.require(:collaborator).permit(:user_id, :todo_list_id)
  end
end
  