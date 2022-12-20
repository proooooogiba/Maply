# frozen_string_literal: true

class MapsController < ApplicationController
  before_action :authenticate_user!
  include MapsHelper

  def index
    @users = User.all_except(current_user).search(params)
  end

  def find_nearest
    @users = sort_by_distance_all(current_user)
    @nearest_person = @users.first
  end

  def find_nearest_friend
    redirect_to root_path if current_user.followers.nil?
    @users = sort_by_distance_followers(current_user)
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
