class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expirate, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "notification.send_reset_mail"
      redirect_to root_url
    else
      flash.now[:danger] = t "notification.not_correct_emails"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("notification.not_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "notification.reset_pass_succes"
      redirect_to @user
    else
      flash[:warning] = t "notification.unvalidate_pass"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def load_user
    @user = User.find_by email: params[:email]
    action_if_user_nil unless @user
  end

  def action_if_user_nil
    redirect_to root_url
    flash[:danger] = t "notification.notfound"
  end

  def valid_user
    flag = @user.activated? && @user.authenticated?(:reset, params[:id])
    action_if_invalid_user unless flag
  end

  def action_if_invalid_user
    redirect_to root_url
    flash[:danger] = t "notification.invalid_reset_pass"
  end

  def check_expirate
    action_if_password_reset_expired if @user.password_reset_expired?
  end

  def action_if_password_reset_expired
    flash[:danger] = t "notification.expired_password_reset"
    redirect_to new_password_reset_url
  end
end
