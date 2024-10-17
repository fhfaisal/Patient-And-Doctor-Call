import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/channel_helper.dart';

class DoctorController extends GetxController {
  late RtcEngine engine;
  final RxInt? remoteUid = 0.obs;
  final RxBool localUserJoined = false.obs;
  RxBool isMuted = false.obs;
  RxBool isVideoEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    initAgora();
  }

  Future<void> initAgora() async {
    final hasPermissions = await AppHelper.requestPermissions();
    if (!hasPermissions) return;
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: AppHelper.appId,channelProfile: ChannelProfileType.channelProfileCommunication));

    engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        print("Local user ${connection.localUid} joined");
        localUserJoined.value = true;
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        print("Remote user $remoteUid joined");
        this.remoteUid!.value = remoteUid;
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        print("Remote user $remoteUid left channel");
        this.remoteUid!.value = 0;
      },
    ));

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();
  }

  Future<void> joinChannel(String channelName) async {
    await engine.joinChannel(
      token: AppHelper.tempToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Toggle mute
  void toggleMute() {
    isMuted.value = !isMuted.value;
    engine.muteLocalAudioStream(isMuted.value);
  }

  // Toggle video visibility
  void toggleVideo() {
    isVideoEnabled.value = !isVideoEnabled.value;
    engine.muteLocalVideoStream(!isVideoEnabled.value);
  }

  // Leave the channel
  Future<void> endCall() async {
    await engine.leaveChannel();
    remoteUid!.value = 0;
    localUserJoined.value = false;
  }

  @override
  void onClose() {
    engine.leaveChannel();
    engine.release();
    super.onClose();
  }
}
