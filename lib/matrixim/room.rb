class MatrixIM::Room
  attr_reader :id
  attr_reader :events
  attr_reader :members
  attr_reader :messages
  attr_reader :latest_messages

  def initialize(connection)
    @connection = connection
    @user = connection.user
    @members = []
    @messages = []
  end

  def create(name:, topic:, visibility: "private")
    raise "" unless %w[public private private_trusted].include?(visibility)
    payload = {
      preset: "#{visibility}_chat",
      # room_alias_name: name,
      name: name,
      topic: topic
      # creation_content: {
      #   m_federate: false
      # },
      # initial_state: [],
      # invite: [],
      # visibility: visibility
    }.to_json
    response = RestClient.post "#{@connection.url}/_matrix/client/r0/createRoom?access_token=#{@user.token}", payload
    parse_create_body(response.body) if response.code == 200
    response.code    
  end

  def join(id_or_alias:)
    payload = {
    #   roomIdOrAlias: id_or_alias
    #   # third_party_signed: nil # Optional
    }.to_json
    response = RestClient.post "#{@connection.url}/_matrix/client/r0/join/#{URI.escape(id_or_alias)}?access_token=#{@user.token}", payload
    parse_join_body(response.body) if response.code == 200
    response.code
  end

  def leave
  end

  # def members
  # end

  # def messages
  #   payload = {
  #     access_token: @user.token,
  #   #   room_id: @id,
  #     from: ,
  #   #   to: nil, # Optional
  #   #   dir: "b",
  #   #   limit: nil # Optional
  #   }
  #   response = RestClient.get "#{@connection.url}/_matrix/client/r0/rooms/#{URI.escape(@id)}/messages?access_token=#{@user.token}"#, payload
  #   parse_message_body(response.body) if response.code == 200
  #   response.code    
  # end

  def state
  end

  def sync
    # headers = {
    #   access_token: @user.token,
    #   # filter:,
    #   # since:,
    #   # full_state: false,
    #   # set_presence: "offline",
    #   timeout: 30000
    # }
    url = "#{@connection.url}/_matrix/client/r0/sync?access_token=#{@user.token}"
    url += "&since=#{@next_batch}" if @next_batch
    response = RestClient.get url
    parse_sync_body(response.body) if response.code == 200
    response.code
  end

  def send_message(message)
    payload = {
      msgtype: "m.text",
      body: message
    }.to_json
    response = RestClient.post "#{@connection.url}/_matrix/client/r0/rooms/#{URI.encode(@id)}/send/m.room.message?access_token=#{@user.token}", payload
    response.code
  end

  private

  def parse_join_body(body)
    body = JSON.parse(body)
    @id = body["room_id"]
  end

  def parse_create_body(body)
    body = JSON.parse(body)
    @id = body["room_id"]
  end

  def parse_sync_body(body)
    body = JSON.parse(body)
    @latest_messages = []
    @next_batch = body["next_batch"]
    begin
      @events = body["rooms"]["join"][@id]["timeline"]["events"]
      @events.each do |event|
        case event["type"]
        when "m.room.create" then nil
        when "m.room.member" then event["content"]["membership"] == "join" ? @members << event["content"]["displayname"] : @members.delete(event["content"]["displayname"])
        when "m.room.power_levels" then nil
        when "m.room.join_rules" then nil
        when "m.room.history_visibility" then nil
        when "m.room.guest_access" then nil
        when "m.room.name" then nil
        when "m.room.topic" then nil
        when "m.room.message" then @latest_messages << { sender: event["sender"], body: event["content"]["body"], msgtype: event["content"]["msgtype"] }
        end
      end
      @messages << @latest_messages
    rescue
    ensure
      @messages.flatten!      
    end
  end
end