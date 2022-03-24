class AdminsController < ApplicationController
    before_action :authenticate_admin!
    
    def admin_home

    end

    def transactions
        @transactions = Transaction.all
    end

    def users
        @users = User.all
    end

end
