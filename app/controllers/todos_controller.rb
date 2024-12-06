class TodosController < ApplicationController
  skip_forgery_protection
  before_action :set_todo_list
  before_action :set_todo, only: [:update, :destroy, :show]

 
   def index
    @todo_list = policy_scope(TodoList).find_by(id: params[:todo_list_id])

    if @todo_list
      todos = @todo_list.todos
      render json: todos, status: :ok
    else
      render json: { error: 'Todo list not found or unauthorized' }, status: :not_found
    end
  end
  
  # POST /todo_list/:todo_list_id/todos
  def create
    return unless @todo_list 
    authorize @todo_list, :add_todo?

    todo = @todo_list.todos.build(todo_params)
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

    if @todo.update(todo_params)
      render json: @todo, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE  by /todo_list/:todo_list_id/todos/:id
  def destroy
    return render json: { error: 'Todo not found' }, status: :not_found unless @todo
    authorize @todo
    if @todo.destroy
      render json: { message: 'Todo deleted successfully' }, status: :ok
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
  def set_todo_list
    @todo_list = policy_scope(TodoList).find_by(id: params[:todo_list_id])
    render json: { error: 'Todo list not found' }, status: :not_found unless @todo_list
  end
  
  def set_todo
    @todo = @todo_list.todos.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, 'Todo not found' unless @todo
  end

  def todo_params
    params.require(:todo).permit(:title, :status)
  end

  