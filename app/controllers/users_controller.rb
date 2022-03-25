class UsersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_user, only: %i[update show edit destroy approve]
    before_action :user_params, only: %i[update create]
    def index
        @users = User.all
    end

    def new
        @user = User.new
    end

    def edit
    end

    def update

        if @user.valid_password?(user_params[:current_password])
            if @user.update(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
                redirect_to users_all_path
            else
                render 'edit'
            end
        else
            redirect_to edit_user_path(@user), notice:"Current password is incorrect"
        end
    end

    def create
        if User.create(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
            redirect_to users_all_path, notice: "User has been created"
        end
    end

    def destroy
        if @user.destroy
            redirect_to users_all_path, notice: "User was successfully destroyed"
        end
    end

    def approve
        if @user.update(approved: true)
            redirect_to users_all_path, notice: "#{@user.email} has been approved"
        else
            redirect_to users_all_path, notice: "#{@user.email} approval error"
        end
    end

    private

    def set_user
        @user = User.find_by(id:params[:id])
    end

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end
end
