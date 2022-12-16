class UsersController < ApplicationController
    def index
      @users = User.all
    end
  
    def show
      @user = User.find_by_id(params[:id])
    end

    def user_profile
      @user = current_user
    end
    
end
  