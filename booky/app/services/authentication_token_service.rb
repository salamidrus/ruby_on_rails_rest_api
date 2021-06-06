# Authentication JWT Service
class AuthenticationTokenService
  HMAC_SECRET = 'mys3cr3t'.freeze
  ALGORITM_TYPE = 'HS256'.freeze

  def self.call
    payload = { "test" => "blah" }

    JWT.encode payload, HMAC_SECRET, ALGORITM_TYPE
  end
end
