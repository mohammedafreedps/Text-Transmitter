import 'package:clipboard/clipboard.dart';

void copyToClipboard(String text) {
  FlutterClipboard.copy(text).then((_) {
  }).catchError((error) {
  });
}