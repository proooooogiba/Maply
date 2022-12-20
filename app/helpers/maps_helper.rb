# frozen_string_literal: true

module MapsHelper
    def sort_by_distance_all(current_user)
        User.all_except(current_user).sort_by { |user| Geocoder::Calculations.distance_between([current_user.latitude, current_user.longitude], [user.latitude, user.longitude]) }
    end

    def sort_by_distance_followers(current_user)
        current_user.followers.sort_by { |user| Geocoder::Calculations.distance_between([current_user.latitude, current_user.longitude], [user.latitude, user.longitude]) }
    end

end
