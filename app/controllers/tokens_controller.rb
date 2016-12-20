class TokensController < ApplicationController
  before_filter :require_login 
 
  def get_token
    if current_user == nil
      @username = "unknown"
    else
      @username = current_user.username
    end
    Twilio::Util::AccessToken.new(
      ENV['ACCOUNT_SID'],
      ENV['API_KEY_SID'],
      ENV['API_KEY_SECRET'],
      3600, 
      @username
    )
  end

  def get_grant
    if current_user == nil
      @username = "unknown"
    else
      @username = current_user.username
    end
    grant = Twilio::Util::AccessToken::IpMessagingGrant.new 
    grant.endpoint_id = "Chatty:#{@username.gsub(" ", "_")}:browser"
    grant.service_sid = ENV['IPM_SERVICE_SID']
    grant
  end

  def create
    if current_user == nil
      @username = "unknown"
    else
      @username = current_user.username
    end
    token = get_token
    grant = get_grant
    token.add_grant(grant)
    render json: {username: @username, token: token.to_jwt}
  end
end