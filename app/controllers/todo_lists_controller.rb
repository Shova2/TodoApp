class TodoListsController < ApplicationController
  skip_forgery_protection
  before_action :set_todo_list, only: [:destroy, :show, :update]

  # GET /todo_lists
  def index
    todo_lists = policy_scope(TodoList)
    render json: todo_lists, status: :ok
  end

  # POST /todo_lists
  def create
    todo_list = current_user.todo_lists.build(todo_list_params)
    # authorize todo_list
    if todo_list.save
      render json: todo_list, status: :created
    else
      render json: { errors: todo_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /todo_lists/:id
  def show
    authorize @todo_list
    render json: @todo_list, status: :ok
  end

  # PATCH/PUT /todo_lists/:id
  def update
    authorize @todo_list

    if @todo_list.update(todo_list_params)
      render json: @todo_list, status: :ok
    else
      render json: { errors: @todo_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todo_lists/:id
  def destroy
    authorize @todo_list

    if @todo_list.destroy
      render json: { message: "Todo list deleted successfully" }, status: :ok
    else
      render json: { errors: @todo_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_todo_list
    @todo_list = policy_scope(TodoList).find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, 'Todo list not found' unless @todo_list
  end

  def todo_list_params
    params.require(:todo_list).permit(:title)
  end
end
