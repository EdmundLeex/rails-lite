class TasksController < ApplicationController
  def index
    @tasks = current_user.tasks.all || []

    render :index    
  end

  def create
    debugger
    @task = current_user.tasks.new
    @task.title = params[:task][:title]
    @task.body = params[:task][:body]
    debugger
    
    if @task.save
      redirect_to "/tasks"
    else
      render :index
    end
  end

end