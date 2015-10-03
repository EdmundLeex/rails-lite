class SessionsController < ControllerBase
  def new
    render :new
  end

  def create
    username = params[:user][:username]
    password = params[:user][:password]
    @user = User.find_by_credentials(username, password)

    if @user
      # debugger
      flash[:info] = "Login success."
      redirect_to "/tasks"
    else
      flash.now[:errors] = "Invalid username or password."
      render :new
    end
  end

end