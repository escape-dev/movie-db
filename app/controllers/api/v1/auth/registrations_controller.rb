class Api::V1::Auth::RegistrationsController < ApplicationController
  def create
    @user = User.new(registration_params)

    if @user.save
      base_response(message: "OK", data: { name: @user.name, email: @user.email }, status: :created)
    else
      base_response(message: @user.errors.full_messages.first, status: :unprocessable_entity)
    end
  end

  private

  def registration_params
    params.permit(:name, :email, :password)
  end
end
