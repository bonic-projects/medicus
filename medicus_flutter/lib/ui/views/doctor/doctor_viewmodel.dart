import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/videosdk_service.dart';

class DoctorViewModel extends BaseViewModel {
  final log = getLogger('DoctorViewModel');
  final _videosdkService = locator<VideosdkService>();

  String get sdkToken => _videosdkService.token;

  String _meetingId = "";
  String get meetingId => _meetingId;
  bool get isValidMeetingId => _videosdkService.validateMeetingId(meetingId);

void createMeeting() async {
  String? m = await _videosdkService.createMeeting();
  if(m!=null) {
    _meetingId = m;
    log.i(_meetingId);
    notifyListeners();
  }
}
}
