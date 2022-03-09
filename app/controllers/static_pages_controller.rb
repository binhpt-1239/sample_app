class StaticPagesController < ApplicationController
  def home
    action_if_logged_in if logged_in?
  end

  def help; end

  def log_in; end

  def log_up; end

  private
  def action_if_logged_in
    @micropost = current_user.microposts.build
    posts = current_user.microposts.new_post
    @pagy, @feed_items = pagy posts, items: Settings.digit_6
  end
end
