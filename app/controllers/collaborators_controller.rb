class CollaboratorsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_todo_list, only: [:create]
    before_action :set_collaborator, only: [:destroy]
  
    # POST /todo_lists/:todo_list_id/collaborators
    def create
        if @todo_list.user != current_user
            return render json: { error: 'You are not authorized to perform this action' }, status: :forbidden
        end

      collaborator = @todo_list.collaborators.build(collaborator_params)
      authorize collaborator  

      if collaborator.save
        render json: collaborator, status: :created
      else
        render json: { errors: collaborator.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: [e.record.errors.full_messages.join(', ')] }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotUnique
      render json: { errors: ['Collaborator already exists'] }, status: :unprocessable_entity
    end
  
    # GET /todo_lists/:todo_list_id/collaborators
  def show
    collaborators = @todo_list.collaborators.includes(:user)
    authorize collaborators  
    render json: collaborators.as_json(only: [:id]), status: :ok
  end

  # DELETE /collaborators/:id
  def destroy
    authorize @collaborator  

    if @collaborator.destroy
      render json: { message: 'Collaborator removed successfully' }, status: :ok
    else
      render json: { errors: @collaborator.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
    private
    def set_todo_list
      @todo_list = TodoList.find_by(id: params[:todo_list_id])
      unless @todo_list
        render json: { error: 'Todo list not found' }, status: :not_found
      end
    end
  
    def set_collaborator
      @collaborator = Collaborator.find_by(id: params[:id])
      unless @collaborator
        render json: { error: 'Collaborator not found' }, status: :not_found
      end
    end
  
    def collaborator_params
      params.require(:collaborator).permit(:user_id, :todo_list_id)
    end
  end
  