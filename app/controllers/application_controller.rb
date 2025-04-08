class ApplicationController < ActionController::API
  include JwtToken

  def authenticate_user
    @current_user = current_user_by_token

    base_response(message: "Please log in to continue.", status: :unauthorized) if @current_user.nil?
  end

  def base_response(params = {})
    render json: {
      message: params[:message],
      data: params[:data]
    }, status: params[:status] || :ok
  end

  private

  def current_user_by_token
    header = request.headers["Authorization"]
    return nil unless header.present?

    token = header.split(" ").last
    return nil unless token

    decoded = JwtToken.decode(:access, token)
    return nil unless decoded

    User.find_by_id(decoded[:user_id])
  end
end
