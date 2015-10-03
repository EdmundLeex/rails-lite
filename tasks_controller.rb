class TasksController < ControllerBase
  def index
    @tasks = Task.all

    flash.now["errors"] = "oh year!!!"

    render :index
    
    # redirect_to '/show'
  end

  def show
    @task = Task.find(params[:id])
    
    # debugger
    render :show
  end

  def new
    @task = Task.new

    render :new
  end

  def create
    # debugger
    @task = Task.new(name: params[:task][:title])
    @task.body = params[:task][:body]

    if @task.save
      redirect_to "/task/#{@task.id}"
    end
  end

end