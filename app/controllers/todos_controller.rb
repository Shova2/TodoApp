class TodosController < ApplicationController
    skip_forgery_protection only: [:create,:update, :destroy]

    # GET /todos
  def index
    todos = Todo.all
    render json: todos, status: :ok
  end

    # POST /todos
  def create
    todo = Todo.new(todo_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /todos/:1
  def update
    todo = Todo.find(params[:id])

    # update the completed status based on the `completed` parameter
    if todo.update(completed: params[:completed])
      render json: todo, status: :ok
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE  by id ---todos/:id
  def destroy 
    todo = Todo.find(params[:id])

    if todo.destroy
      render json: { message: 'Todo deleted successfully' }, status: :ok
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private

  def todo_params
    params.require(:todo).permit(:title, :completed)
  end
end
