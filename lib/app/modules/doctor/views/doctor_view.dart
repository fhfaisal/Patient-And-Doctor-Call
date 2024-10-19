import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/commonWidgets/call_controller.dart';
import '../../doctor_list_screen.dart';
import '../controllers/doctor_controller.dart';

class DoctorView extends StatelessWidget {
  const DoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Doctor Role")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => DoctorListScreen(isPatient: false));
          },
          child: const Text("Choose Doctor Role"),
        ),
      ),
    );
  }
}

class DoctorVideoCallScreen extends StatelessWidget {
  //final String channelName;
  final DoctorController controller = Get.put(DoctorController());

  //DoctorVideoCallScreen({super.key, required this.channelName});

  @override
  Widget build(BuildContext context) {
    controller.joinChannel(controller.channelName);
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor Video Call")),
      body: Obx(() {
        if (controller.localUserJoined.value) {
          return Stack(
            children: [
              _remoteVideo(),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: controller.engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
              CallController(controller: controller),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Widget _remoteVideo() {
    return Obx(() => controller.remoteUid!.value == 0
        ? const Center(
            child: Text('Please wait for joining'),
          )
        : AgoraVideoView(
            controller: VideoViewController.remote(
            rtcEngine: controller.engine,
            canvas: VideoCanvas(uid: controller.remoteUid!.value),
            connection: RtcConnection(channelId: controller.channelName),
          )));
  }
}
