import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texttransmitter/services/clipboard_monitor.dart';
import 'package:texttransmitter/services/server.dart';

class ClientProvider extends ChangeNotifier {
  ClipBoardMonitor clipBoardMonitor = ClipBoardMonitor();
  String recivedText = '';
  bool isConnectedToServer = false;
  bool isLoading = false;
  String errorMes = '';
  TextEditingController IPAddressController = TextEditingController();
  TextEditingController clientMessageController = TextEditingController();

  ClientProvider() {
    setSavedIPAddress();
  }

  void setSavedIPAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IPAddressController.text = prefs.getString('IP') ?? '';
  }

  void onConnectToServer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('IP', IPAddressController.text.trim());
    if (IPAddressController.text.isNotEmpty) {
      isLoading = true;
      errorMes = '';
      notifyListeners();
      ServerManager.connectServer(
        IPAddress: IPAddressController.text.trim(),
        onMessageRecive: ({required message}) {
          recivedText = message;
          notifyListeners();
        },
        onConnected: (status) {
          isConnectedToServer = status;
          clipBoardMonitor.initClipboardWatcher();
          isLoading = false;
          notifyListeners();
        },
        onError: ({required errorMessage}) {
          print(errorMessage);
          isLoading = false;
          errorMes = errorMessage;
          notifyListeners();
        },
      );
    } else {
      errorMes = 'Enter IP Address';
      notifyListeners();
    }
  }

  void sentMessageToPc(){
    ServerManager.sentFromMobile(clientMessageController.text);
    clientMessageController.clear();
  }

  void onDisconnectFromServer() {
    isLoading = true;
    ServerManager.disconnectClient(
      onDisconnected: ({required status}) {
        if (status == true) {
          isConnectedToServer = false;
          clipBoardMonitor.stopClipboardWatcher();
          isLoading = false;
          notifyListeners();
        }
      },
    );
  }
}
