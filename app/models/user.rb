class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:google_oauth2, :vkontakte, :github]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name   # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.from_omniauth_vk(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = "auth-info@email.com"
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name   # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.from_omniauth_github(access_token)
    data = access_token.info
    puts data['email']
    puts data['email']
    puts data['email']
    puts data['email']
    puts data['email']
    puts data['email']
    
    user = User.where(email: data['email']).first
    unless user
        user = User.create(
           full_name: data['name'],
           email: data['email'],
           password: Devise.friendly_token[0,20]
        )
    end
    user
  end
end
