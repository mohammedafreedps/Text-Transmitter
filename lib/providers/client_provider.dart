import 'package:flutter/material.dart';
import 'package:texttransmitter/services/clipboard_monitor.dart';
import 'package:texttransmitter/services/server.dart';

class ClientProvider extends ChangeNotifier {
  ClipBoardMonitor clipBoardMonitor = ClipBoardMonitor();
  String recivedText = '';
  bool isConnectedToServer = false;
  bool isLoading = false;

  void onConnectToServer() {
    isLoading = true;
    notifyListeners();
    ServerManager.connectServer(onMessageRecive: ({required message}) {
      recivedText = message;
      notifyListeners();
    },onConnected: (status) {
      isConnectedToServer = status;
      clipBoardMonitor.initClipboardWatcher();
      isLoading = false;
      notifyListeners();
    },);
  }

  void onDisconnectFromServer(){
    isLoading = true;
    ServerManager.disconnectClient(onDisconnected: ({required status}) {
      if(status == true){
        isConnectedToServer = false;
        clipBoardMonitor.stopClipboardWatcher();
        isLoading = false;
        notifyListeners();
      }
    },);
  }
}
