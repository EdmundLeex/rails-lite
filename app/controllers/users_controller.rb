class UsersController < ApplicationController
  def index
    @users = User.all

    render :index
  end

  def show
    @user = User.find(params[:id])
    render :show
  end

  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(username: params[:user][:username])
    @user.password = params[:user][:password]

    if @user.save
      login(@user)
      redirect_to "/tasks"
      # redirect_to "/user/#{@user.id}"
    else
      flash.now["errors"] = "Oops... Something has gone wrong."
      render :new
    end
  end
end