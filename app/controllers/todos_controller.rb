class TodosController < ApplicationController
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :set_todo_list
  before_action :set_todo, only: [:update, :destroy, :show]

    # GET /todo_lists/:todos_list_id/todos
  def index
    authorize @todo_list, :show?

    todos = @todo_list.todos
    render json: todos, status: :ok
  end

    # POST /todo_list/:todo_list_id/todos
  def create
    todo = @todo_list.todos.build(todo_params)

    authorize todo

    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end


  #Get /todo_lists/:todo_list_id/todos/:id
  def show
    authorize @todo
    render json: @todo, status: :ok
  end

  # PUT /todo_list/:todo_list_id/todos/:id
  def update
    authorize @todo

    if @todo.update(todo_params)
      render json: @todo, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE  by /todo_list/:todo_list_id/todos/:id
  def destroy
    authorize @todo

    if @todo.destroy
      render json: { message: 'Todo deleted successfully' }, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
 def set_todo_list
  # Fetch the todo_list either for the current user or if they are a collaborator
  @todo_list = TodoList.find_by(id: params[:todo_list_id])
  
  # Check if the current user is either the owner or a collaborator of the todo_list
  unless @todo_list && (user_is_owner? || collaborator?)
    render json: { error: "Todo list not found or you don't have permission" }, status: :not_found
  end
 end

  # Check if the current user is the owner of the todo list
  def user_is_owner?
    @todo_list.user == current_user
  end

  # Check if the current user is a collaborator on the todo list
  def collaborator?
    @todo_list.collaborators.exists?(user_id: current_user.id)
  end

  def set_todo
    @todo = @todo_list.todos.find_by(id: params[:id])
    unless @todo
      render json: { error: "Todo not found" }, status: :not_found 
    end
  end

  def todo_params
    params.require(:todo).permit(:title, :status)
  end
end
