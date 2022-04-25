class VisitorMailer < ApplicationMailer
  def magic_link_requested(email, token)
    @token = token
    @email = email

    mail(to: email, subject: "Magic Link to log in to Yggdrasil")
  end
end
