import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';
import '../models/device.dart';

const dbCode = "uKSs70Yyuqesigf5AhVpMCNn41Y2";

class RtdbService with ListenableServiceMixin {
  final log = getLogger('RealTimeDB_Service');

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceReading? _node;
  DeviceReading? get node => _node;

  void setupNodeListening() {
    DatabaseReference starCountRef = _db.ref('/devices/$dbCode/reading');
    starCountRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        _node = DeviceReading.fromMap(event.snapshot.value as Map);
        // log.v(_node?.lastSeen); //data['time']
        notifyListeners();
      }
    });
  }


  Future<DeviceData?> getDeviceData() async {
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/data');
    final value = await dataRef.once();
    if (value.snapshot.exists) {
      return DeviceData.fromMap(value.snapshot.value as Map);
    }
    return null;
  }

  void setDeviceData(DeviceData data) {
    log.i("Setting device data");
    DatabaseReference dataRef = _db.ref('/devices/$dbCode/data');
    dataRef.update(data.toJson());
  }
}
