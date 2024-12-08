import 'dart:io';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:texttransmitter/services/server.dart';

class ClipBoardMonitor with ClipboardListener {

   void initClipboardWatcher()async{
    clipboardWatcher.addListener(this);
    await clipboardWatcher.start();
  }

  void stopClipboardWatcher()async{
    clipboardWatcher.removeListener(this);
    await clipboardWatcher.stop();
  }

  @override
  void onClipboardChanged() async {
    ClipboardData? newClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if(Platform.isWindows){
      ServerManager.sentFromPc(newClipboardData?.text ?? '');
    }
    if(Platform.isAndroid){
      ServerManager.sentFromMobile(newClipboardData?.text ?? '');
    }
  }
}