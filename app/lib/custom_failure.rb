# app/lib/custom_failure.rb
class CustomFailure < Devise::FailureApp
    def redirect_url
      # Avoid redirecting back to sign-in if already authenticated
      if user_signed_in?
        admin_dashboard_path # Redirect to the admin dashboard if already signed in
      else
        super
      end
    end
  
    def respond
      if http_auth?
        http_auth
      else
        redirect
      end
    end
  end
  