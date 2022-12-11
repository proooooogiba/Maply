class MapsController < ApplicationController
    before_action :authenticate_user!

    def index

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
end
