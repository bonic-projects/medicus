/// Device Sensor Reading model
class DeviceReading {
  String rfid;
  DateTime lastSeen;

  DeviceReading({
    required this.lastSeen,
    required this.rfid,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      rfid: data['rfid'] ?? "",
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}

class DeviceReading2 {
  String pin;
  DateTime lastSeen;

  DeviceReading2({
    required this.lastSeen,
    required this.pin,
  });

  factory DeviceReading2.fromMap(Map data) {
    return DeviceReading2(
      pin: data['pin'] ?? "",
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}

/// Device control model
class DeviceData {
  bool stepper1;
  bool stepper2;
  bool redLed;
  bool greenLed;
  bool buzzer;
  bool reset;
  int m1;
  int m2;

  DeviceData({
    required this.stepper1,
    required this.stepper2,
    required this.redLed,
    required this.greenLed,
    required this.buzzer,
    required this.reset,
    required this.m1,
    required this.m2,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      stepper1: data['stepper1'] ?? false,
      stepper2: data['stepper2'] ?? false,
      redLed: data['redLed'] ?? false,
      greenLed: data['greenLed'] ?? false,
      buzzer: data['buzzer'] ?? false,
      reset: data['reset'] ?? false,
      m1: data['m1'] ?? 0,
      m2: data['m2'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'stepper1': stepper1,
        'stepper2': stepper2,
        'redLed': redLed,
        'greenLed': greenLed,
        'buzzer': buzzer,
        'reset': reset,
        'm1': m1,
        'm2': m2,
      };
}
