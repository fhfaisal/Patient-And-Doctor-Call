import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CallController extends StatelessWidget {
  const CallController({
    super.key,
    required this.controller,
  });

  final controller;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mute/Unmute button
            Obx(() {
              return IconButton(
                icon: Icon(
                  controller.isMuted.value ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: controller.toggleMute,
                color: Colors.blue,
                iconSize: 30,
              );
            }),
            // Toggle video button
            Obx(() {
              return IconButton(
                icon: Icon(
                  controller.isVideoEnabled.value ? Icons.videocam : Icons.videocam_off,
                  color: Colors.white,
                ),
                onPressed: controller.toggleVideo,
                color: Colors.blue,
                iconSize: 30,
              );
            }),
            // End call button
            IconButton(
              icon: const Icon(Icons.call_end, color: Colors.red),
              onPressed: controller.endCall,
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}