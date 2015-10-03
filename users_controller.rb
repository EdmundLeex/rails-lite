class UsersController < ApplicationController
  def index
    @users = User.all

    flash.now["errors"] = "oh year!!!"

    render :index
    # render_content($cats.to_s, "text/text")
    
    # redirect_to '/show'
  end

  def show
    @user = User.find(params[:id])

    # @owner = @user.human
    # @house = @owner.house unless @owner.nil?
    
    # debugger
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
      redirect_to "/user/#{@user.id}"
    end
  end

end