require "jwt"

module JwtToken
  extend ActiveSupport::Concern

  TOKEN_TYPES = {
    access: {
      duration: 1.hours.to_i,
      key_env: "JWT_ACCESS_TOKEN"
    },
    refresh: {
      duration: 7.hours.to_i,
      key_env: "JWT_REFRESH_TOKEN"
    }
  }.freeze

  def self.encode(payload, key, exp)
    payload[:exp] = exp.to_i

    JWT.encode(payload, key)
  end

  def self.decode(token, key)
    return nil unless token

    begin
      decoded = JWT.decode(token, key)[0]

      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT decode error: #{e.message}")

      nil
    end
  end

  def self.generate_token(type, payload)
    key = ENV[TOKEN_TYPES[type][:key_env]]
    exp = Time.current + TOKEN_TYPES[type][:duration]
    token = encode(payload, key, exp)

    { token: token, exp_at: exp }
  end
end
