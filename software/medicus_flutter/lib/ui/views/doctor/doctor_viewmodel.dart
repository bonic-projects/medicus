import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/device.dart';
import '../../../services/rtdb_service.dart';
import '../../../services/videosdk_service.dart';

class DoctorViewModel extends ReactiveViewModel {
  final log = getLogger('DoctorViewModel');
  final _videosdkService = locator<VideosdkService>();

  final _dbService = locator<RtdbService>();
  @override
  List<ListenableServiceMixin> get listenableServices => [_dbService];

  DeviceReading? get node => _dbService.node;


  String get sdkToken => _videosdkService.token;

  String _meetingId = "";
  String get meetingId => _meetingId;
  bool get isValidMeetingId => _videosdkService.validateMeetingId(meetingId);

  void onModelReady(bool isUser){
      if(node!=null) {
        print("dvsdgv");
        _meetingId = node!.rfid;
        log.i(_meetingId);
        notifyListeners();
    }
  }
}
