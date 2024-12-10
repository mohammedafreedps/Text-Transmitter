import 'dart:io';
import 'package:flutter/material.dart';
import 'package:texttransmitter/KEY.dart';
import 'package:texttransmitter/services/copy_to_clipboard.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerManager {
  static HttpServer? server;
  static WebSocketChannel? channel;
  static WebSocket? socket;

  static Future<void> startServer(
      {required Function({int? port, required bool serverStatus}) onServerStart,
      required Function({required bool clientConnected}) onClientConnected,
      required Function({required String message}) onMessageRecived,
      required Function({required bool clientConnected})
          onClientDisconnected}) async {
    try {
      server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      onServerStart(serverStatus: true, port: server?.port);
      server!.listen(
        onError: (Object error, StackTrace stackTrace){
        },
        onDone: () {
      },(HttpRequest request) async {
        if (request.uri.path == '/ws') {
          socket = await WebSocketTransformer.upgrade(request);
          onClientConnected(clientConnected: true);
          socket?.listen((data) {
            onMessageRecived(message: data);
            copyToClipboard(data);
          },onDone: (){
            onClientDisconnected(clientConnected: true);
          });
        } else {
          request.response.statusCode = HttpStatus.forbidden;
          request.response.close();
        }
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<void> stopServer(
      {required Function({required bool isServerStopped})
          onServerStopped}) async {
    try {
      if (socket != null && socket?.readyState == WebSocket.open) {
        socket?.close();
      }
      await server?.close(force: true);
      onServerStopped(isServerStopped: true);
    } catch (e) {
      throw e;
    }
  }

  static Future<void> connectServer(
      {required String IPAddress,required Function({required String message}) onMessageRecive,
      required Function(bool status) onConnected,required Function({required String errorMessage})onError}) async {
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://$IPAddress:8080/ws'));
      await channel?.ready;
      onConnected(true);
      channel?.stream.listen((message) {
        onMessageRecive(message: message);
        copyToClipboard(message);
      }, onError: (error) {
        onConnected(false);
      }, onDone: () {
        onConnected(false);
      });
    } catch (e) {
      onError(errorMessage: e.toString());
    }
  }

  static void disconnectClient(
      {required Function({required bool status}) onDisconnected}) async {
    try {
      if (channel != null) {
        await channel?.sink.close();
        onDisconnected(status: true);
      } else {
      }
    } catch (e) {
      throw e;
    }
  }

  static void sentFromPc(String text) {
    socket?.add(text);
  }

  static void sentFromMobile(String text) {
    channel?.sink.add(text);
  }
}
