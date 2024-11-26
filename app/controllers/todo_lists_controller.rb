class TodoListsController < ApplicationController
  skip_forgery_protection
   before_action :authenticate_user!
   before_action :set_todo_list, only: [:destroy]
   
   #get/todo_lists
   def index
    todo_lists = current_user.todo_lists
    render json: todo_lists, status: :ok
   end

   #post /todo_lists
   def create
    todo_list = current_user.todo_lists.build(todo_list_params)
    if todo_list.save
      render json: todo_list, status: :created
    else
      render json: { errors: todo_list.errors.full_messages }, status: :unprocessable_entity
    end
   end

   #delete /todo_lists/:id
   def destroy
     if @todo_list.destroy
       render json: { message: "Todo list deleted sucessfully" }, status: :ok
     else 
       render json: { errors: @todo_list.errors.full_messages }, status: :unprocessable_entity
     end
   end
      
   private

  def set_todo_list
    @todo_list = current_user.todo_lists.find_by(id: params[:id])
    render json: { error: "Todo list not found" }, status: :not_found unless @todo_list
  end

  def todo_list_params
    params.require(:todo_list).permit(:title)
  end
  end





  # skip_forgery_protection
    # # GET /users/:user_id/todo_lists
    # def index
    #   user = User.find(params[:user_id]) 
    #   todo_lists = user.todo_lists       
    #   render json: todo_lists, status: :ok
    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "User not found" }, status: :not_found
    # end
  
    # # POST /users/:user_id/todo_lists
    # def create
    #   user = User.find(params[:user_id]) 
    #   # Associate todo_list with the user
    #   todo_list = user.todo_lists.build(todo_list_params) 
    #   if todo_list.save
    #     render json: todo_list, status: :created
    #   else
    #     render json: { errors: todo_list.errors.full_messages }, status: :unprocessable_entity
    #   end
    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "User not found" }, status: :not_found
    # end
  
    # # DELETE /users/:user_id/todo_lists/:id
    # def destroy
    #   user = User.find(params[:user_id]) # Fetch the user by ID
    #   todo_list = user.todo_lists.find_by(id: params[:id]) # Find the todo_list by ID within the user's todo_lists
  
    #   if todo_list
    #     if todo_list.destroy
    #       render json: { message: "Todo list deleted successfully" }, status: :ok
    #     else
    #       render json: { errors: todo_list.errors.full_messages }, status: :unprocessable_entity
    #     end
    #   else
    #     render json: { error: "Todo list not found" }, status: :not_found
    #   end
    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "User not found" }, status: :not_found
    # end
  
    # private
  
    # # Strong parameters to permit only necessary attributes
    # def todo_list_params
    #   params.require(:todo_list).permit(:title)
    # end
  