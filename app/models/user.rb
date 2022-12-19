# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 vkontakte github]

  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }
  has_many :messages
  followability

  def unfollow(user)
    followerable_relationships.where(followable_id: user.id).destroy_all
  end

  def self.search(params)
    if params[:query].blank?
      none
    else
      where(
        'full_name LIKE ?', "%#{sanitize_sql_like(params[:query])}%"
      )
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.from_omniauth_vk(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = 'auth-info@email.com'
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.from_omniauth_github(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    user ||= User.create(
      full_name: data['name'],
      email: data['email'],
      password: Devise.friendly_token[0, 20],
      avatar_url: data['image'],
      provider: access_token.provider,
      uid: access_token.uid
    )
    user
  end
end
