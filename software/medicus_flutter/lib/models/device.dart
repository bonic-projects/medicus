/// Device Sensor Reading model
class DeviceReading {
  int heartRate;
  double temp;
  String rfid;
  DateTime lastSeen;

  DeviceReading({
    required this.lastSeen,
    required this.rfid,
    required this.temp,
    required this.heartRate,
  });

  factory DeviceReading.fromMap(Map data) {
    return DeviceReading(
      rfid: data['rfid'] ?? "",
      temp: data['temp'] ?? 0.0,
      heartRate: data['heartRate'] ?? 0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}

/// Device control model
class DeviceData {
  bool isOpen1;
  bool isOpen2;
  bool isOpen3;
  String content;
  int m1;
  int m2;
  int m3;

  DeviceData({
    required this.isOpen1,
    required this.isOpen2,
    required this.isOpen3,
    required this.content,
    required this.m3,
    required this.m1,
    required this.m2,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      isOpen1: data['isOpen1'] ?? false,
      isOpen2: data['isOpen2'] ?? false,
      isOpen3: data['isOpen3'] ?? false,
      content: data['content'] ?? "",
      m1: data['m1'] ?? 0,
      m2: data['m2'] ?? 0,
      m3: data['m3'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'isOpen1': isOpen1,
        'isOpen2': isOpen2,
        'isOpen3': isOpen3,
        'content': content,
        'm1': m1,
        'm2': m2,
        'm3': m3,
      };
}
