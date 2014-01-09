class UserMailer < ActionMailer::Base
  default from: "hello@followmytravel.com"
  layout 'mailer_default'

  def registration_confirmation(user)
      @user = user
      mail(:to => user.email, :subject => "Добро пожаловать!")
  end


 class Preview < MailView
    def user_email
      user = User.first
      mail = UserMailer.registration_confirmation(user)
      mail
    end
  end
end
