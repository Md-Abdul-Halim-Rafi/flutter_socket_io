import 'package:socket_io_client/socket_io_client.dart' as socket_io;

socket_io.Socket socket =
    socket_io.io('https://d5d0-103-216-56-196.ap.ngrok.io', <String, dynamic>{
  "transports": ["websocket"],
  "autoConnect": false,
});

void socketInit() {
  socket.connect();

  socket.onConnect((_) {
    print("Connected");
    // socket.emit('msg', 'test');
  });

  socket.emit("join_community_chat", null);

  socket.onDisconnect((_) => print('disconnected'));
}
