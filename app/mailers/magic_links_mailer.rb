class MagicLinksMailer < ApplicationMailer
  def notification(email, token)
    @token = token
    mail(to: email, subject: 'Magic Link to log in to Yggdrasil')
  end
end
