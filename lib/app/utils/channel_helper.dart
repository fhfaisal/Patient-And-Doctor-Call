

import 'package:permission_handler/permission_handler.dart';

class AppHelper{
 static const appId='1f34ed959af04340ba1cf6ac3d68150c';
 static const tempToken='0061f34ed959af04340ba1cf6ac3d68150cIABZIkvnUkRm3/vekC+QTsS91RAsEASGJiX5qP6xGIg5Hwx+f9jSY0iIIgB9BqaPAN8UZwQAAQCQmxNnAgCQmxNnAwCQmxNnBACQmxNn';
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