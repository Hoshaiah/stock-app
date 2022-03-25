class AdminMailer < ApplicationMailer
    def admin_approval(user)
        @user = user
        mail(to: @user.email, subject: 'Welcome to My Awesome Site')
      end
end
