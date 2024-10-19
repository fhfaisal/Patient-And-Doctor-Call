import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/app/data/TOKEN_RESPONSE.dart';
import 'package:untitled1/app/repository/api_service.dart';

import '../../../utils/channel_helper.dart';

class DoctorController extends GetxController {
  late RtcEngine engine;
  final RxInt? remoteUid = 0.obs;
  final RxBool localUserJoined = false.obs;
  RxBool isMuted = false.obs;
  RxBool isVideoEnabled = true.obs;
  final channelName=Get.arguments;
  final Rx<TokenResponse> tokenResponse= TokenResponse().obs;

  @override
  void onInit() {
    super.onInit();
    channelName;
    print("I got The Arguments $channelName");
    getToken();
    initAgora();
  }
  Future<TokenResponse?> getToken() async {
    //Map<String, dynamic> values = {'api_token': apiToken, 'customer_id': customerId};
    try {
      await ApiService().getToken(channelName: channelName).then((response) {
        if (response != null) {
          tokenResponse.value = response;
          //print(tokenResponse.value.channelName);
          //print(tokenResponse.value.token);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }


  Future<void> initAgora() async {
    final hasPermissions = await AppHelper.requestPermissions();
    if (!hasPermissions) return;
    engine = createAgoraRtcEngine();
    await engine.initialize(const RtcEngineContext(appId: AppHelper.appId,channelProfile: ChannelProfileType.channelProfileCommunication));

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

  Future<void> joinChannel() async {
    try{
        await engine.joinChannel(
          token: '0061f34ed959af04340ba1cf6ac3d68150cIACbnxXsauDyGy1tgAQuA1AhM4QpMAn5CcFh+PlSf9ajieLcsooAAAAAIgAqqmflKQkVZwQAAQC5xRNnAgC5xRNnAwC5xRNnBAC5xRNn',
          channelId: channelName,
          uid: 0,
          options: const ChannelMediaOptions(),
        );
    }catch(e){}
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
