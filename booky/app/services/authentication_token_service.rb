# Authentication JWT Service
class AuthenticationTokenService
  HMAC_SECRET = 'mys3cr3t'.freeze
  ALGORITM_TYPE = 'HS256'.freeze

  def self.call(user_id)
    payload = { user_id: user_id }

    JWT.encode payload, HMAC_SECRET, ALGORITM_TYPE
  end

  def self.decode(token)
    decoded_token = JWT.decode token, HMAC_SECRET, true, { algorithm: ALGORITM_TYPE }
    decoded_token[0]['user_id']
  end
end
