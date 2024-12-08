import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texttransmitter/main.dart';
import 'package:texttransmitter/providers/client_provider.dart';
import 'package:texttransmitter/services/server.dart';
import 'package:texttransmitter/widgets/app_button.dart';

class HomwScreenAndroid extends StatelessWidget {
  const HomwScreenAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.watch<ClientProvider>().isLoading ? const CircularProgressIndicator(color: Colors.black87,) :
          context.watch<ClientProvider>().isConnectedToServer
              ? AppButton(
                  lable: 'Disconnect',
                  backgroundColor: Colors.red,
                  onClick: () {
                    context.read<ClientProvider>().onDisconnectFromServer();
                  })
              : AppButton(
                  backgroundColor: Colors.green,
                  lable: 'Connect',
                  onClick: () {
                    print('button clickeing');
                    context.read<ClientProvider>().onConnectToServer();
                  },
                ),
          context.watch<ClientProvider>().isConnectedToServer ? Text('Server Connected') : SizedBox(),
          SizedBox(height: 40,),
          context.watch<ClientProvider>().recivedText.isNotEmpty
              ? SelectableText(context.watch<ClientProvider>().recivedText)
              : const SizedBox()
        ],
      )),
    );
  }
}
