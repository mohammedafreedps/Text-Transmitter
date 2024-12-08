import 'package:flutter/material.dart';
import 'package:texttransmitter/services/clipboard_monitor.dart';
import 'package:texttransmitter/services/get_ip_address.dart';
import 'package:texttransmitter/services/server.dart';

class ServerProvider extends ChangeNotifier {
  ClipBoardMonitor clipBoardMonitor = ClipBoardMonitor();
  int openedPortNumber = 0;
  bool isServerStarted = false;
  bool isClientConnected = false;
  String IPv4Address = '';
  String recivedText = '';

  void toStartServer() async {
    IPv4Address = await getIPv4Address() ?? 'Ip Could not found';
    notifyListeners();
    await ServerManager.startServer(
      onServerStart: ({required serverStatus, port}) {
        isServerStarted = serverStatus;
        openedPortNumber = port ?? 0;
        notifyListeners();
      },
      onClientConnected: ({required clientConnected}) {
        isClientConnected = true;
        clipBoardMonitor.initClipboardWatcher();
        notifyListeners();
      },
      onMessageRecived: ({required message}){
        recivedText = message;
        notifyListeners();
      },
      onClientDisconnected: ({required clientConnected}) {
        isClientConnected = false;
        notifyListeners();
      },
    );
  }

  void toStopServer() async {
    await ServerManager.stopServer(
      onServerStopped: ({required isServerStopped}) {
        if (isServerStopped) {
          isServerStarted = false;
          openedPortNumber = 0;
          isClientConnected = false;
          clipBoardMonitor.stopClipboardWatcher();
          notifyListeners();
        }
      },
    );
  }
}