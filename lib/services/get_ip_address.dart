import 'dart:io';

Future<String?> getIPv4Address() async {
  try {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          return addr.address;
        }
      }
    }
    return null; 
  } catch (e) {
    throw e;
  }
}
