class TodosController < ApplicationController
    skip_forgery_protection only: [:create,:update, :destroy]

    # GET /todo_lists/:todos_list_id/todos
  def index
    todo_list = TodoList.find(params[:todo_list_id])
    todos = todo_list.todos
    render json: todos, status: :ok
  end

    # POST /todo_list/:todo_list_id/todos
  def create

    todo_list = TodoList.find(params[:todo_list_id])
    todo = todo_list.todos.build(todo_params)
    #default value --pending
    todo.status ||= 'pending'


    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /todo_list/:todo_list_id/todos/:id

  def update
    todo_list = TodoList.find(params[:todo_list_id])
    todo = todo_list.todos.find(params[:id])

  # update the completed status based on the `completed` parameter
    if todo.update(todo_params)
      render json: todo, status: :ok
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE  by /todo_list/:todo_list_id/todos/:id
  def destroy
    todo_list = TodoList.find(params[:todo_list_id])
    todo = todo_list.todos.find(params[:id])

    if todo.destroy
      render json: { message: 'Todo deleted successfully' }, status: :ok
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def todo_params
    params.require(:todo).permit(:title,  :status)
  end
end
