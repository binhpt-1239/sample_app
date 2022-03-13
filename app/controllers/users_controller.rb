class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(create new)
  before_action :load_user, except: %i(create new index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.microposts.all, items: Settings.digit_6
    return if @user

    redirect_to root_path
    flash[:warning] = t "notification.notfound"
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:success] = t "notification.send_activate_mail"
      redirect_to root_url
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
    else
      flash[:warning] = t "notification.not_destroy"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @pagy, @users = pagy @user.following, items: Settings.digit_6
    render "show_follow"
  end

  def followers
    @title = t "followers"
    @pagy, @users = pagy @user.followers, items: Settings.digit_6
    render "show_follow"
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
