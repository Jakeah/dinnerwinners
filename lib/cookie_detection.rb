# Rails.root.to_s/lib/cookie_detection.rb
 
# Detects if cookies are present.
# If cookies are disabled, shows view located at shared/cookies_required
# Usage:
# * save this file at a location in your rails app where it gets required
#   (e.g. Rails.root.to_s/lib)
# * application_controller:
#   Include CookieDetection (at the top to make this the first before_filter)
# * routes.rb:
#   map.cookies_test "cookie_test", :controller => "application", :action => "cookie_test"
# * views/shared/cookies_required.html.erb:
#   Display a message that lets your users know of the cookie requirement.
module CookieDetection
  # :nocov:
  #def self.included(base)
  #  base.before_filter :cookies_required, :except => ["cookie_test"]
  #end
 
  # checks for presence of "cookie_test" cookie
  # (should have been set by cookies_required before_filter)
  # if cookie is present, continue normal operation
  # otherwise show cookie warning at "shared/cookies_required"
  def cookie_test
    if cookies["cookie_test"].blank? && !Rails.env.test?
      #logger.warn("=== cookies are disabled")
      #render :template => "shared/cookies_required", :layout => "system"
      redirect_to :controller => 'welcome', :action => 'cookies_must_be_enabled'
    else
      redirect_to session[:return_to]
    end
  end
 
protected
 
  # checks for presence of "cookie_test" cookie.
  # If not present, redirects to cookies_test action
  def cookies_required
    return true unless cookies["cookie_test"].blank?
    cookies["cookie_test"] = Time.now
    session[:return_to] = request.request_uri
    redirect_to(cookies_test_path)
  end
  # :nocov:
end