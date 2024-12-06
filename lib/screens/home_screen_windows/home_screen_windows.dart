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
      body: Center(
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
            context.watch<ServerProvider>().openedPortNumber != 0
                ? Text(
                    'Port: ${context.watch<ServerProvider>().openedPortNumber.toString()}')
                : const SizedBox(),

                context.watch<ServerProvider>().isClientConnected
                ? Text(
                    'Client : Connected')
                : Text('Client : Not Connected')
          ],
        ),
      ),
    );
  }
}
