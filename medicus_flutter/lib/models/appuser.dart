class AppUser {
  final String id;
  final String fullName;
  final String rfid;
  final DateTime registeredOn;
  final String email;
  final String pin;
  // final String gender;
  final String userRole;
  int balance;

  AppUser({
    required this.id,
    required this.fullName,
    required this.rfid,
    required this.registeredOn,
    required this.email,
    required this.pin,
    // required this.gender,
    required this.userRole,
    required this.balance,
  });

  AppUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        rfid = data['rfid'] ?? "",
        registeredOn = data['tokenTime'] != null
            ? data['tokenTime'].toDate()
            : DateTime(2022),
        email = data['email'],
        pin = data['pin'] ?? "",
        // gender = data['gender'],
        userRole = data['userRole'] ?? "user",
        balance = data['balance'] ?? 100;

  Map<String, dynamic> toJson(keyword) {
    return {
      'id': id,
      'fullName': fullName,
      'rfid': rfid,
      'tokenTime': registeredOn,
      'keyword': keyword,
      'email': email,
      'pin': pin,
      // 'gender': gender,
      'userRole': userRole,
      'balance': balance,
    };
  }
}
