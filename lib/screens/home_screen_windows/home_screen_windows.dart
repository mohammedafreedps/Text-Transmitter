import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texttransmitter/main.dart';
import 'package:texttransmitter/providers/server_provider.dart';
import 'package:texttransmitter/services/clipboard_monitor.dart';
import 'package:texttransmitter/widgets/app_button.dart';

class HomeScreenWindows extends StatelessWidget {
  HomeScreenWindows({super.key});

  final ClipBoardMonitor CM = ClipBoardMonitor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              context.watch<ServerProvider>().isServerStarted
                  ? AppButton(
                      lable: 'Stop Server',
                      backgroundColor: Colors.red,
                      onClick: () {
                        context.read<ServerProvider>().toStopServer();
                      },
                    )
                  : AppButton(
                      lable: 'Start Server',
                      backgroundColor: Colors.green,
                      onClick: () {
                        context.read<ServerProvider>().toStartServer();
                      },
                    ),
              context.watch<ServerProvider>().isServerStarted ? Text('IP: ${context.watch<ServerProvider>().IPv4Address}') : Text('IP: ---.--.--'),
              context.watch<ServerProvider>().openedPortNumber != 0
                  ? Text(
                      'Port: ${context.watch<ServerProvider>().openedPortNumber.toString()}')
                  : const Text('Port: ----'),
        
                  context.watch<ServerProvider>().isClientConnected
                  ? const Text(
                      'Client : Connected')
                  : const Text('Client : Not Connected'),
        
              SizedBox(height: 40,),
              context.watch<ServerProvider>().recivedText.isNotEmpty ? Text(context.watch<ServerProvider>().recivedText) : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
