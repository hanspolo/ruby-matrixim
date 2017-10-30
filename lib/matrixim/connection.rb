class MatrixIM::Connection
  attr_reader :user
  attr_reader :rooms
  attr_reader :url

  def initialize(url)
    @url = url
    @rooms = []
  end

  def create_user(username, password)
    @user = MatrixIM::User.new(self, username: username, password: password)
    @user
  end

  def create_room
    raise 'please login or register an user first' unless @user&.token
    r = MatrixIM::Room.new(self)
    @rooms << r
    r
  end
end