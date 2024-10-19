

import 'package:permission_handler/permission_handler.dart';

class AppHelper{
 static const appId='1f34ed959af04340ba1cf6ac3d68150c';
 static const tempToken='007eJxTYOjauKBzwrn9+R4eYbpTCiMLml756yz3iV52+8sGkylnE88pMBimGZukpliaWiamGZgYmxgkJRomp5klJhunmFkYmhok350hnN4QyMgQFPeBiZEBAkF8FoaS1OISBgYAvIshEg==';

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