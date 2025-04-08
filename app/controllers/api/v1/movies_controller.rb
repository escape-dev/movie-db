class Api::V1::MoviesController < ApplicationController
  before_action :authenticate_user

  def popular
    base_response(message: "OK", data: TmdbApi.get(:popular, params[:page]))
  end

  def upcoming
    base_response(message: "OK", data: TmdbApi.get(:upcoming, params[:page]))
  end

  def top_rated
    base_response(message: "OK", data: TmdbApi.get(:top_rated, params[:page]))
  end

  def now_playing
    base_response(message: "OK", data: TmdbApi.get(:now_playing, params[:page]))
  end
end
