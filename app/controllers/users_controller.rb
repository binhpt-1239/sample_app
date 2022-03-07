class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new)
  before_action :load_user, except: %i(create new index)
  before_action :correct_user, only: %i(edit update show)
  before_action :admin_user, only: %i(destroy index)

  def new
    @user = User.new
  end

  def show
    return if @user

    redirect_to root_path
    flash[:warning] = t "notification.notfound"
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "notification.success"
      redirect_to @user
    else
      flash.now[:warning] = t "notification.err"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "notification.update"
      redirect_to @user
    else
      flash.now[:warning] = t "notification.not_update"
      render :edit
    end
  end

  def index
    @pagy, @users = pagy User.all, items: Settings.digit_6
  end

  def destroy
    if @user.destroy
      flash[:success] = t "notification.destroy"
      redirect_to users_url
    else
      flash[:warning] = t "notification.not_destroy"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    action_if_not_found_user unless @user
  end

  def action_if_not_found_user
    redirect_to users_path
    flash[:danger] = t "notification.notfound"
  end

  def logged_in_user
    action_if_not_logged_in unless logged_in?
  end

  def action_if_not_logged_in
    store_location
    flash[:danger] = t "notification.request_login"
    redirect_to login_url
  end

  def correct_user
    flag = current_user?(@user) || current_user.admin?
    action_if_not_correct_user unless flag
  end

  def action_if_not_correct_user
    redirect_to root_url
    flash[:danger] = t "notification.not_do"
  end

  def admin_user
    action_if_not_admin unless current_user.admin?
  end

  def action_if_not_admin
    redirect_to root_url
    flash[:danger] = t "notification.not_admin"
  end
end
