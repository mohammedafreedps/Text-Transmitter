import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texttransmitter/providers/client_provider.dart';
import 'package:texttransmitter/widgets/app_button.dart';

class HomwScreenAndroid extends StatelessWidget {
  const HomwScreenAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            context.watch<ClientProvider>().recivedText.isNotEmpty
                ? SizedBox(height: 100,child: Text(context.watch<ClientProvider>().recivedText,overflow: TextOverflow.ellipsis,))
                : const SizedBox(),
            context.watch<ClientProvider>().errorMes.isNotEmpty
                ? Text('Error: \n${context.watch<ClientProvider>().errorMes}')
                : const SizedBox(),
            !context.watch<ClientProvider>().isConnectedToServer ?  TextField(
              controller: context.read<ClientProvider>().IPAddressController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  hintText: 'Enter IP Address',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            ) : 
            TextField(
              controller: context.read<ClientProvider>().clientMessageController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                  hintText: 'Enter Message',
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            )
            ,
            context.watch<ClientProvider>().isLoading
                ? const CircularProgressIndicator(
                    color: Colors.black87,
                  )
                : context.watch<ClientProvider>().isConnectedToServer
                    ? Column(
                      children: [
                        AppButton(
                            lable: 'Sent',
                            backgroundColor: Colors.black87,
                            onClick: () {
                              context
                                  .read<ClientProvider>()
                                  .sentMessageToPc();
                            }),
                            SizedBox(height: 30,),
                        AppButton(
                            lable: 'Disconnect',
                            backgroundColor: Colors.red,
                            onClick: () {
                              context
                                  .read<ClientProvider>()
                                  .onDisconnectFromServer();
                            }),
                      ],
                    )
                    : AppButton(
                        backgroundColor: Colors.green,
                        lable: 'Connect',
                        onClick: () {
                          context.read<ClientProvider>().onConnectToServer();
                        },
                      ),
          ],
        )),
      ),
    );
  }
}