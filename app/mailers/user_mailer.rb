class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: Settings.subject_activate_mail
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: Settings.subject_reset_pass_mail
  end
end
