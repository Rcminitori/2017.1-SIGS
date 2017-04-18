class UserController < ApplicationController
  before_action :logged_in?, except: [:new,:create,:user_params]
  def new
    @user = User.new
  end

  def show
      @user = User.find(params[:id])
      if @user.id != current_user.id && permission != 3
        redirect_to current_user
      end
  end

  #Creating a new user
  def create
  	@user = User.new(user_params)
    if @user.save
    end
  end

  # Editing the user profile
  def edit
    if @user != current_user
    end
  end

  #Update User
  def update
    if @user.update(user_params)
      flash[:success] = t(:sucessful_profile_update)
      redirect_to @user
    else
      flash[:warning] = t(:error_profile_update)
    end
  end

  private
  def user_params
    params[:user].permit(:name, :email, :password, :registration, :cpf, :active)
  end
end
