class UserSessionsController < ApplicationController
#  before_filter :require_no_user, :only => [:new, :create]
#  before_filter :require_user, :only => :destroy

  layout 'cmu_sv'


 # Additional reading:
 # http://openidenabled.com/files/ruby-openid/repos/2.x.x/UPGRADE

  def create
    open_id_authentication
  end

  def destroy
    current_user_session.destroy
#    @user_session = UserSession.find
#    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end

  protected
  def open_id_authentication
    authenticate_with_open_id(params[:openid_identifier], :required => ["http://axschema.org/contact/email", "http://axschema.org/namePerson/first", "http://axschema.org/namePerson/last"]) do |result, identity_url, registration|
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
            logger.info "creating new user account"
            @current_user = User.new({:first_name => first_name, :last_name=>last_name, :email=>email})
            @current_user.save #Note AuthLogic creates the session too
            #send email to help@sv.cmu.edu -- similar to twiki email
          else
            logger.info "creating new user sessoin"
#            @user_session = UserSession.new(params[:user_session])
            @user_session = UserSession.create(@current_user, true)
 #           @user_session.save

          end
          if current_user
            successful_login
          else
            failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
          end
        else
          failed_login result.message
        end
      end
    end
  end

  private
  def successful_login
#    @user_session = UserSession.create(@current_user, true)
#    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_back_or_default(root_url)
##      redirect_back_or_default(user_session_url)
#      redirect_to root_url
#              redirect_to(user_session_url)
      #        redirect_to(root_url)
#    else
#      render :action => 'new'
#    end
  end

      def successful_login_old
        session[:user_id] = @current_user.id
        redirect_to(user_session_url)
#        redirect_to(root_url)
      end
  


  def failed_login(message)
#    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"

    flash[:error] = message
    redirect_to(new_user_session_url)
  end

end