import 'package:flutter/material.dart';
import 'package:texttransmitter/services/clipboard_monitor.dart';
import 'package:texttransmitter/services/server.dart';

class ServerProvider extends ChangeNotifier {
  ClipBoardMonitor clipBoardMonitor = ClipBoardMonitor();
  int openedPortNumber = 0;
  bool isServerStarted = false;
  bool isClientConnected = false;


  void toStartServer()async{
    await ServerManager.startServer(onServerStart: ({required serverStatus, port}) {
      print('${isServerStarted.toString()} from the server method');
      isServerStarted = serverStatus;
      openedPortNumber = port ?? 0;
      notifyListeners();
    },onClientConnected:({required clientConnected}) {
      isClientConnected = true;
      clipBoardMonitor.initClipboardWatcher();
      notifyListeners();
    },);
  }

  void toStopServer()async{
    await ServerManager.stopServer(onServerStopped: ({required isServerStopped}) {
      if(isServerStopped){
        isServerStarted = false;
        openedPortNumber = 0;
        isClientConnected = false;
        clipBoardMonitor.stopClipboardWatcher();
        notifyListeners();
      }
    },);
  }
}