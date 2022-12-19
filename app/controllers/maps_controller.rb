# frozen_string_literal: true

class MapsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all_except(current_user).search(params)
  end

  def find_nearest
    @users = User.all_except(current_user)
    current_user_location = [current_user.latitude, current_user.longitude]
    @users = @users.sort_by do |user|
      Geocoder::Calculations.distance_between(current_user_location, [user.latitude, user.longitude])
    end
    @nearest_person = @users.first
  end

  def find_nearest_friend
    redirect_to root_path if current_user.followers.nil?
    @users = current_user.followers
    current_user_location = [current_user.latitude, current_user.longitude]
    @users = @users.sort_by do |user|
      Geocoder::Calculations.distance_between(current_user_location, [user.latitude, user.longitude])
    end
    @nearest_friend = @users.first
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
    if user_signed_in?
      puts "User #{current_user} is authenticated"
    else
      puts "User isn't authenticated"
      redirect_to new_user_session_path
    end
  end
end
