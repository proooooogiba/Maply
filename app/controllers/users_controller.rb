class UsersController < ApplicationController
    def index
      @users = User.all
    end
  
    def show
      @user = current_user
    end

    def user_profile
      @user = User.find_by_email(params[:email])
    end
  end
  