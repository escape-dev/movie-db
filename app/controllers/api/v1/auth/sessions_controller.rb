class Api::V1::Auth::SessionsController < ApplicationController
  JWT_ACCESS_TOKEN = ENV["JWT_ACCESS_TOKEN"]
  JWT_REFRESH_TOKEN = ENV["JWT_REFRESH_TOKEN"]

  def create
    @user = User.find_by_email(session_params[:email])

    if @user&.authenticate(session_params[:password])
      payload = { user_id: @user.id }

      base_response(message: "OK", data: generate_tokens(payload), status: :created)
    else
      base_response(message: "invalid email or password", status: :unauthorized)
    end
  end

  def refresh_token
    @token = JwtToken.decode(:refresh, params[:refresh_token])
    @user = User.find_by_id(@token[:user_id]) if @token.present?

    if @user.present?
      payload = { user_id: @user.id }

      base_response(message: "OK", data: generate_tokens(payload), status: :created)
    else
      base_response(message: "invalid token", status: :bad_request)
    end
  end

  private

  def generate_tokens(payload)
    {
      access_token: JwtToken.generate_token(:access, payload),
      refresh_token: JwtToken.generate_token(:refresh, payload)
    }
  end

  def session_params
    params.permit(:email, :password)
  end
end
