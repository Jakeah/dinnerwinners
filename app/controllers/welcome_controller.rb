class WelcomeController < ApplicationController
  include RFC822

  def index
  
  end

  def login
    # TODO check if account !closed and user not a problem Also warn if account delinquent
    #reset_session
    Rails.logger.level = Rails.env.production? ? 3 : 0
    if request.post? && params[:password] && !params[:password].strip.blank?
      clean_session_info
      user = User.authenticate(params[:email].strip, params[:password].strip)
      if user
        flash[:notice] = ''
        set_session_info(user)
        uri = session[:original_uri]
        session[:original_uri] = nil
        Rails.logger.info "REQUESTED URI was #{uri}" unless uri.blank?
        if user.is_admin
          redirect_to(uri || {action: 'admin_dashboard'})
        else # user.is_organization_admin or location_admin   TODO what about responder
          if !uri.blank?
            redirect_to(uri)
          else
            redirect_to({action: 'dashboard'})
          end
        end
      else
        if params[:fail_path].blank?
          @hide_login = true # hides the login in the header
        else
          redirect_to :action => params[:fail_path]
        end

      end
    elsif request.post? && (params[:password].nil? || params[:password].blank?)
      @user_name = params[:email]
      flash[:alert] = 'Please enter a password'

    else # request not a post. get the cookie
      @user_name = params[:email]
      @hide_login = true # hides the login in the header

    end
  end

  def admin_dashboard
  end

  def cookies_must_be_enabled

    requested_path = params[:requested_path]
    referrer = params[:referrer]

    cause = "a user caused cookies_must_be_enabled when requesting #{requested_path} coming from #{referrer} at #{request.remote_ip}. "
    cause += "\nMessage:\n cookies_must_be_enabled"

  end

end
