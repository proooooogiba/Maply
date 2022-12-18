class MapsController < ApplicationController
    before_action :authenticate_user!
    
    def index
      @users = User.all_except(current_user).search(params)
    end

    def result
        @latitude = params[:latitude]
        @longitude = params[:longitude]
        @user = current_user
        @user.latitude = @latitude
        @user.longitude = @longitude
        @user.save
    end

private

def authenticate_user!
    unless user_signed_in?
      puts "User isn't authenticated"
      redirect_to new_user_session_path
    else 
      puts "User #{current_user} is authenticated"
    end
  end

end
