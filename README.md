# ruby-matrixim
## About
A library to access the API of the matrix messanger. 
To learn more about matrix see their homepage [https://matrix.org/](https://matrix.org/).

## Example
```ruby
require 'matrixim'

conn = MatrixIM::Connection.new("https://matrix.org:8448")
user = conn.create_user("USERNAME", "PASSWORD")
user.login

room = conn.create_room
# Create a new room
room.create(name: "Name of the new Room", topic: "Adding a nice topic")
# Or join an existing room
room.join(id_or_alias: "!ROOM_KEY:matrix.org")

# Get the latest activities from the room
room.sync

puts room.members.inspect
puts room.messages.inspect

room.send_message("Gem testing")
```

## License
[MIT](https://github.com/hanspolo/ruby-matrixim/blob/master/LICENSE)