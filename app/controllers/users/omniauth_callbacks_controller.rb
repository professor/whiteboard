class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_apps
    # You need to implement the method below in your model
    @user = User.find_for_google_apps_oauth(env["omniauth.auth"], current_user)

    omniauth = env["omniauth.auth"]
    email = switch_west_to_sv(omniauth["user_info"]["email"])

    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider'], :email => email
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:error] = "Sorry, no user with this email (#{email}) exists in the system. help@sv.cmu.edu was just notified of this issue."
      options = {:to => "help@sv.cmu.edu",
                 :subject => "Login problem to on rails.sv.cmu.edu for user #{email}",
                 :message => "A user tried to log into the rails application. They were authenticated by google, however, their email address does not exist as a person in the system. Either 1) the person is already in the system, but there is a typo with their email address or 2)the person needs to be added to the system. <br><br>The email address is #{email}",
                 :url_label => "",
                 :url => "",
                 :cc => "todd.sedano@sv.cmu.edu"
      }
      GenericMailer.email(options).deliver
      session["devise.google_apps_data"] = env["omniauth.auth"]
      redirect_to root_url
    end


    #if @user.persisted?
    #  flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => omniauth['provider']
    #  sign_in_and_redirect @user, :event => :authentication
    #else
    #  flash[:error] = "Sorry, no user with this email (#{email}) exists in the system. help@sv.cmu.edu was just notified of this issue."
    #
    #  session["devise.google_apps_data"] = env["omniauth.auth"]
    #  redirect_to root_url
    #end
    #      User.create(:email => data["email"], :first_name => data["first_name"], :last_name => data["last_name"], :human_name => "name")
    #      options = {:to => "help@sv.cmu.edu",
    #                 :subject => "Login problem to on rails.sv.cmu.edu for user #{email}",
    #                 :message => "A user tried to log into the rails application. They were authenticated by google, however, their email address does not exist as a person in the system. Either 1) the person is already in the system, but there is a typo with their email address or 2)the person needs to be added to the system. <br><br>The email address is #{email}",
    #                 :url_label => "",
    #                 :url => "",
    #                 :cc => "todd.sedano@sv.cmu.edu"
    #      }
    #      GenericMailer.email(options).deliver
    #      failed_login "Sorry, no user with this email (#{email}) exists in the system. help@sv.cmu.edu was just notified of this issue."    if @user.persisted?
    #      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
    #      sign_in_and_redirect @user, :event => :authentication
    #    else
    #      session["devise.facebook_data"] = env["omniauth.auth"]
    #      redirect_to new_user_registration_url
    #    end

  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end