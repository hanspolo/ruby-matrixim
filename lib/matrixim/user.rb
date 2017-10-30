class MatrixIM::User

  attr_reader :token

  def initialize(connection, username:, password:)
    @connection = connection
    @username = username
    @password = password
  end

  def register
    payload = {
      username: @username,
      password: @password,
      auth: {
        type: "m.login.dummy"
      }
    }.to_json
    response = RestClient.post "#{@connection.url}/_matrix/client/r0/register", payload
    parse_register_body(response.body) if response.code == 200
    response.code
  end

  ##
  # Signs in the user.
  #
  # There are multiple status codes that describe the response
  # 200: Login went fine.
  # 400: Part of the request was invalid. For example, the login type may not be recognised.
  # 403: The login attempt failed. For example, the password may have been incorrect.
  # 429: This request was rate-limited.
  #
  def login
    payload = {
      type: "m.login.password",
      user: @username,
      password: @password
    }.to_json
    response = RestClient.post "#{@connection.url}/_matrix/client/r0/login", payload
    parse_login_body(response.body) if response.code == 200
    response.code
  end

  ##
  # Signs out the user.
  # 
  #
  def logout
    response = RestClient.post "#{@connection.url}/_matrix/client/r0/logout?access_token=#{@token}"
    response.code
  end

  private

  def parse_register_body(body)
    body = JSON.parse(body)
    @id = body["user_id"]
    @token = body["access_token"]
  end

  ##
  # { "application/json": "{\n  \"user_id\": \"@cheeky_monkey:matrix.org\",\n  \"access_token\": \"abc123\",\n  \"home_server\": \"matrix.org\"\n}" }
  #
  def parse_login_body(body)
    body = JSON.parse(body)
    @id = body["user_id"]
    @token = body["access_token"]
  end
end