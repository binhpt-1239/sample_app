module UsersHelper
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = Settings.users.user_url + gravatar_id
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def currentuser_is_admin? user
    current_user.admin? && !current_user?(user)
  end
end
