class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user

  def current
    base_response(message: "OK", data: @current_user.as_json(only: %i[ id name email ]))
  end
end
