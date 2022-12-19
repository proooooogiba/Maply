# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]

    # You should also create an action method in this controller like this:
    # def twitter
    # end

    def google_oauth2
      user = User.from_omniauth(auth)
      if user.present?
        sign_out_all_scopes
        flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect user, event: :authentication # this will throw if @user is not activated
      else
        flash[:alert] =
          t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: user.errors.full_messages.to_sentence.to_s
        redirect_to new_user_session_path
      end
    end

    def github
      user = User.from_omniauth_github(request.env['omniauth.auth'])

      if user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
        sign_in_and_redirect user, event: :authentication
      else
        session['devise.github_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
        redirect_to new_user_session_path, alert: user.errors.full_messages.join("\n")
      end
    end

    # More info at:
    # https://github.com/heartcombo/devise#omniauth

    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end

    # GET|POST /users/auth/twitter/callback
    # def failure
    #   super
    # end

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
    private

    def auth
      @auth ||= request.env['omniauth.auth']
    end
  end
end
