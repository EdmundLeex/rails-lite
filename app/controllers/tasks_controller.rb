class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks || []

    render :index    
  end

  def create
    @task = current_user.tasks.new
    @task.title = params[:task][:title]
    @task.body = params[:task][:body]
    if @task.save
      redirect_to "/tasks"
    else
      render :index
    end
  end

end