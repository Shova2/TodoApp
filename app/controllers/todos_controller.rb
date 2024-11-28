class TodosController < ApplicationController
  skip_forgery_protection
  before_action :authenticate_user!
  before_action :set_todo_list
  before_action :set_todo, only: [:update, :destroy, :show]

    # GET /todo_lists/:todos_list_id/todos
  def index
    todos = @todo_list.todos
    render json: todos, status: :ok
  end

    # POST /todo_list/:todo_list_id/todos
  def create
    todo = @todo_list.todos.build(todo_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #Get /todo_lists/:todo_list_id/todos/:id
  def show
    render json: @todo, status: :ok
  end

  # PUT /todo_list/:todo_list_id/todos/:id
  def update
  if @todo.update(todo_params)
    render json: @todo, status: :ok
  else
    render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
   end
  end

  # DELETE  by /todo_list/:todo_list_id/todos/:id
  def destroy
    
    if @todo.destroy
       puts "Updated Todo: #{@todo.inspect}"
      render json: { message: 'Todo deleted successfully' }, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
  def set_todo_list
    @todo_list = current_user.todo_lists.find_by(id: params[:todo_list_id])
    unless @todo_list
      render json: { error: "Todo list not found" }, status: :not_found 
    end
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
