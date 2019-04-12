require 'rfc822'

class ApplicationController < ActionController::Base
  helper :all


  protected
  def set_session_info(user)
    session[:user_id] = user.id
    session[:user_name] = user.full_name
    #LoginHistory.create :user_id => user.id, :ip_address => request.remote_ip

    if user.is_god_admin
      session[:is_god_admin] = true
      session[:is_admin] = true
    elsif user.is_admin
      session[:is_admin] = true
      session.delete(:is_god_admin)
    else
      session.delete(:is_god_admin)
      session.delete(:is_admin)
    end

  end

  def clean_session_info
    session.delete(:is_admin)
    session.delete(:is_god_admin)
    session.delete(:user_id)
    session.delete(:user_name)
  end

  def send_to_login_page
    session[:original_uri] = request.fullpath
    flash[:alert] = 'Please log in'
    redirect_to :controller => 'welcome', :action => 'index'
  end

end
