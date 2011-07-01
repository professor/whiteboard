class UserSessionsController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
#  before_filter :require_user, :only => :destroy

  layout 'cmu_sv'


 # Additional reading:
 # http://openidenabled.com/files/ruby-openid/repos/2.x.x/UPGRADE

  def login_google
    open_id_authentication("west.cmu.edu")
  end

  def new
    @user_session = UserSession.new
  end

  def create
    if !Rails.env.development? || !params[:user_session]
      open_id_authentication
    else
          @user_session = UserSession.new(params[:user_session])
          if @user_session.save
            flash[:notice] = "Login successful!"
            redirect_back_or_default(root_path)
          else
            flash[:notice] = "Login unsuccessful"
            render :action => :new
          end
    end

#      if using_open_id?
#        open_id_authentication
#      else
#        password_authentication(params[:name], params[:password])
#      end

  end

  def destroy
    current_user_session.destroy
#    @user_session = UserSession.find
#    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_path
  end

  protected
  def open_id_authentication(openid_identifier = params[:openid_identifier])
    authenticate_with_open_id(openid_identifier, :required => ["http://axschema.org/contact/email", "http://axschema.org/namePerson/first", "http://axschema.org/namePerson/last"]) do |result, identity_url, registration|
      ax_response = OpenID::AX::FetchResponse.from_success_response(request.env[Rack::OpenID::RESPONSE])
      case result.status
      when :missing
        failed_login "Sorry, the OpenID server couldn't be found"
      when :invalid
        failed_login "Sorry, but this does not appear to be a valid OpenID"
      when :canceled
        failed_login "OpenID verification was canceled"
      when :failed
        failed_login "Sorry, the OpenID verification failed"
      when :successful

        email = ax_response['http://axschema.org/contact/email'].first()
        first_name = ax_response['http://axschema.org/namePerson/first'].first()
        last_name = ax_response['http://axschema.org/namePerson/last'].first()

        email = switch_west_to_sv(email)
        logger.info "email: #{email}"

        if result.successful?
          p registration.data
          @current_user = User.find_by_email(email)
          if @current_user.nil?
#            logger.info "creating new user account"
#            @current_user = Person.new({:first_name => first_name, :last_name=>last_name, :email=>email})
#            @current_user.save_without_session_maintenance #Note AuthLogic creates the session too
#            @current_user = User.find_by_email(email)
          end
          logger.info "creating new user session"
          @user_session = UserSession.create(@current_user, true)
          if current_user
            successful_login(openid_identifier, email)
          else
            GenericMailer.deliver_email(
              :to => "help@sv.cmu.edu",
              :subject => "Login problem to on rails.sv.cmu.edu for user #{email}",
              :message => "A user tried to log into the rails application. They were authenticated by google, however, their email address does not exist as a person in the system. Either 1) the person is already in the system, but there is a typo with their email address or 2)the person needs to be added to the system. <br><br>The email address is #{email}",
              :url_label => "",
              :url => "",
              :cc => "todd.sedano@sv.cmu.edu"
            )
            failed_login "Sorry, no user with this email (#{email}) exists in the system. help@sv.cmu.edu was just notified of this issue."
          end
        else
          failed_login result.message
        end
      end
    end
  end

  private
  def successful_login(openid_identifier, email)
    if openid_identifier == "west.cmu.edu"
      flash[:notice] = "You are now logged in with your google account, #{email}"
    else
      flash[:notice] = "Successfully logged in."
    end

#    @user_session = UserSession.create(@current_user, true)
#    if @user_session.save
      redirect_back_or_default(root_path)
##      redirect_back_or_default(user_session_url)
#      redirect_to root_path
#              redirect_to(user_session_url)
      #        redirect_to(root_path)
#    else
#      render :action => 'new'
#    end
  end

      def successful_login_old
        session[:user_id] = @current_user.id
        redirect_to(user_session_url)
#        redirect_to(root_path)
      end
  


  def failed_login(message)
#    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"



    flash[:error] = message
#    redirect_to(new_user_session_url)
    redirect_to(root_path)
   end

end