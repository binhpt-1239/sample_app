class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :load_micropost, only: %i(edit update)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = t "notification.create_micropost_success"
    else
      flash[:warning] = t "notification.create_micropost_fails"
    end
    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "notification.deleted_micropost"
    else
      flash[:warning] = t "notification.deleted_micropost_fails"
    end
    redirect_to request.referer || root_url
  end

  def edit
    posts = current_user.microposts.new_post
    @pagy, @feed_items = pagy posts, items: Settings.digit_6
    render "static_pages/home"
  end

  def update
    if @micropost.update micropost_params
      flash[:success] = t "notification.micropost_update"
    else
      flash[:warning] = t "notification.micropost_not_update"
    end
    redirect_to root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def load_micropost
    @micropost = current_user.microposts.find_by id: params[:id]
    action_if_not_found_micropost unless @micropost
  end

  def action_if_not_found_micropost
    redirect_to root_url
    flash[:warning] = t "notification.not_found_micropost"
  end

  def correct_user
    @micropost = if current_user.admin?
                   Micropost.find_by id: params[:id]
                 else
                   current_user.microposts.find_by id: params[:id]
                 end
    action_if_not_found_micropost unless @micropost
  end
end
