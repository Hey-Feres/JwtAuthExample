class ApplicationController < ActionController::API
  before_action :set_auth_header

  def encode_token(payload)
    JWT.encode(payload, 'Secret Key')
  end

  def auth_header
    request.headers['Authorization'].split(' ')[1]
  end

  def decoded_token
    return unless auth_header.present?

    token = auth_header
    begin
      JWT.decode(token, 'Secret Key', true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def set_auth_header
    response.set_header('Auth-Token', auth_header)
  end

  def logged_user
    return unless decoded_token.present?

    id = decoded_token[0]['user_id']
    @user = User.find(id)
  end

  def is_logged?
    logged_user
  end

  def authorize
    return if is_logged?

    render json: { message: 'You must signin before access this route' }, status: :unauthorized
  end
end
