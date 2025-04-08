require "uri"
require "json"
require "net/http"

class TmdbApi
  TMDB_API_BASE_URL = ENV["TMDB_API_BASE_URL"]
  TMDB_ACCESS_TOKEN = ENV["TMDB_ACCESS_TOKEN"]
  MOVIE_TYPES = {
    popular: "popular",
    upcoming: "upcoming",
    top_rated: "top_rated",
    now_playing: "now_playing"
  }.freeze

  def self.send_request(path)
    url = URI("#{TMDB_API_BASE_URL}#{path}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{TMDB_ACCESS_TOKEN}"
    request["accept"] = "application/json"

    response = http.request(request)

    result = JSON.parse(response.body)
    result["results"]
  rescue StandardError => e
    { error: e.message }
  end

  def self.get(type, page = 1)
    send_request("/movie/#{MOVIE_TYPES[type]}?language=en-US&page=#{page}")
  end
end
