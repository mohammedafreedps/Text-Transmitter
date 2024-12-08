import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:texttransmitter/providers/client_provider.dart';
import 'package:texttransmitter/providers/server_provider.dart';
import 'package:texttransmitter/screens/home_screen_android/home_screen_android.dart';
import 'package:texttransmitter/screens/home_screen_windows/home_screen_windows.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      minimumSize: Size(800, 600),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServerProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Platform.isWindows ? HomeScreenWindows() : HomwScreenAndroid(),
      ),
    );
  }
}
