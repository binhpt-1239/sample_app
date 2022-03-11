class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :check_relationship, only: :create
  before_action :load_relationship, :check_correct_user, only: :destroy

  def create
    action_if_action_follow_fails unless current_user.follow @user
    flash[:success] = t "notification.follow_success"
    redirect_to @user
  end

  def destroy
    action_if_action_follow_fails unless current_user.unfollow @user
    flash[:success] = t "notification.unfollow_success"
    redirect_to @user
  end

  private

  def check_relationship
    @user = User.find_by id: params[:followed_id]
    if @user
      relationship = current_user.active_relationships.find_by followed_id:
                                                          params[:followed_id]
      action_if_relationship_any if relationship
    else
      action_if_user_nil
    end
  end

  def check_correct_user
    @user = @relationship.followed
    if @user
      relationship = current_user.active_relationships.find_by id: params[:id]
      action_if_relationship_nil unless relationship
    else
      action_if_user_nil
    end
  end

  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    return if @relationship

    action_if_relationship_nil
  end

  def action_if_relationship_any
    flash[:warning] = t "notification.were_followed"
    redirect_to request.referer || root_url
  end

  def action_if_relationship_nil
    flash[:warning] = t "notification.were_unfollowed"
    redirect_to request.referer || root_url
  end

  def action_if_user_nil
    flash[:warning] = t "notification.is_nil"
    redirect_to root_url
  end

  def action_if_action_follow_fails
    flash[:warning] = t "notification.fails"
    redirect_to request.referer || root_url
  end
end
