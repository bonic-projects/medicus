import 'dart:async';

import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/device.dart';
import '../../../services/rtdb_service.dart';

class OnlineStatusViewModel extends BaseViewModel {
  final log = getLogger('StatusWidget');

  final _dbService = locator<RtdbService>();

  DeviceReading? get node => _dbService.node;

  bool _isOnline = false;
  bool get isOnline => _isOnline;


  bool isOnlineCheck(DateTime? time) {
    // log.i(" Online check");
    if (time == null) return false;
    final DateTime now = DateTime.now();
    final difference = now.difference(time).inSeconds;
    // log.i("Status $difference ");
    return difference >= 0 && difference <= 8;
  }

  late Timer timer;

  void setTimer() {
    log.i("Setting timer");
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        _isOnline = isOnlineCheck(node?.lastSeen);
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
