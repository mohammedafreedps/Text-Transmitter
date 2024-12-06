import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerManager {
  static HttpServer? server;
  static late WebSocketChannel channel;
  static WebSocket? socket;
  static String serverIP = '192.168.1.11';

  static Future<void> startServer(
      {required Function({int? port, required bool serverStatus})
          onServerStart,
      required Function({required bool clientConnected}) onClientConnected}) async {
    try {
      server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      print(
          'Server running at ws://${server!.address.address}:${server!.port}');
      onServerStart(serverStatus: true, port: server?.port);
      server!.listen((HttpRequest request) async {
        if (request.uri.path == '/ws') {
          socket = await WebSocketTransformer.upgrade(request);
          print('Client connected');
          onClientConnected(clientConnected: true);
          socket?.listen((data) {
            print('Received from client: $data');
            socket?.add('Echo: $data'); // Echo message back to client
          });
        } else {
          request.response.statusCode = HttpStatus.forbidden;
          request.response.close();
          print('Else workded');
        }
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<void> stopServer({required Function({required bool isServerStopped})onServerStopped}) async {
    try {
      if(socket != null && socket?.readyState == WebSocket.open){
        socket?.close();
      }
      await server?.close(force: true);
      onServerStopped(isServerStopped: true);
    } catch (e) {
      throw e;
    }
  }

  static void connectServer({required Function({required String message}) onMessageRecive,required Function(bool status) onConnected}) {
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://$serverIP:8080/ws'));
      onConnected(true);
      channel.stream.listen((message) {
        print(message);
        onMessageRecive(message: message);
      }, onError: (error) {
        print(error);
      }, onDone: () {
        print('WebSocket connection closed.');
      });
    } catch (e) {
      throw e;
    }
  }

  static void disconnectClient({required Function({required bool status}) onDisconnected}) async {
  try {
    if (channel != null) {
      await channel.sink.close();
      onDisconnected(status: true);
      print('Client disconnected from the server.');
    } else {
      print('No active WebSocket connection to close.');
    }
  } catch (e) {
    print('Error while disconnecting client: $e');
  }
}


  static void sentFromPc(String text) {
    socket?.add(text);
  }

  static void sentFromMobile() {
    channel.sink.add('Hellow I am from mobile');
  }
}
