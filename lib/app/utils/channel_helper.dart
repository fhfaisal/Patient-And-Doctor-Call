

import 'package:permission_handler/permission_handler.dart';

class AppHelper{
 static const appId='1f34ed959af04340ba1cf6ac3d68150c';
 static const tempToken='007eJxTYNjiVFsZuNJAo+iC2a4rlT5PS8u8pZsni0wK0DQ4wuyznEmBwTDN2CQ1xdLUMjHNwMTYxCAp0TA5zSwx2TjFzMLQ1CBZf4NAekMgI8PBwMmMjAwQCOKzMJSkFpcwMAAAnb0c7g==';

  static Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      print("Permissions not granted.");
    }
    return allGranted;
  }
}