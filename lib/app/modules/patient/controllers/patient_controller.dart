import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

import '../../../utils/channel_helper.dart';

class PatientController extends GetxController {
  late RtcEngine engine;
  final RxInt? remoteUid = 0.obs;
  final RxBool localUserJoined = false.obs;

  @override
  void onInit() {
    super.onInit();
    initAgora();
  }

  // Initialize Agora engine and join channel
  Future<void> initAgora() async {
    final hasPermissions = await AppHelper.requestPermissions();
    if (!hasPermissions) return;
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: AppHelper.appId));

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

  // Join the channel with a given name
  Future<void> joinChannel(String channelName) async {
    await engine.joinChannel(
      token: AppHelper.tempToken,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Leave the channel
  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    Get.back(); // Navigate back
  }
}