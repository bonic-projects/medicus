import 'dart:async';

import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/device.dart';
import '../../../services/firestore_service.dart';
import '../../../services/rtdb_service.dart';
import '../../../services/user_service.dart';

class DeviceControlViewModel extends ReactiveViewModel {
  final log = getLogger('DeviceControlWidget');
  final _dbService = locator<RtdbService>();
  final _userService = locator<UserService>();
  final _firestoreService = locator<FirestoreService>();

  AppUser? get user => _userService.user;

  @override
  List<ListenableServiceMixin> get listenableServices => [_dbService];

  void setStepper1({bool? isOpen}) {
    if (isOpen != null) {
      if (isOpen) {
        _deviceData!.stepper1 = true;
      } else {
        _deviceData!.stepper1 = false;
      }
    } else {
      _deviceData!.stepper1 = !_deviceData!.stepper1;
    }
    setDeviceData();
    notifyListeners();
  }

  void setStepper2({bool? isOpen}) {
    if (isOpen != null) {
      if (isOpen) {
        _deviceData!.stepper2 = true;
      } else {
        _deviceData!.stepper2 = false;
      }
    } else {
      _deviceData!.stepper2 = !_deviceData!.stepper2;
    }

    setDeviceData();
    notifyListeners();
  }

  void setRedLed() {
    _deviceData!.redLed = !_deviceData!.redLed;
    setDeviceData();
    notifyListeners();
  }

  void setGreenLed() {
    _deviceData!.greenLed = !_deviceData!.greenLed;
    setDeviceData();
    notifyListeners();
  }

  void setBuzzer() {
    _deviceData!.buzzer = !_deviceData!.buzzer;
    setDeviceData();
    notifyListeners();
  }

  void setReset() {
    _deviceData!.reset = !_deviceData!.reset;
    setDeviceData();
    // notifyListeners();
  }

  void changeM1(bool isIncrement) {
    if (isIncrement) {
      _deviceData!.m1++;
    } else {
      _deviceData!.m1--;
      currentUser!.balance = currentUser!.balance - 2;
      _firestoreService.updateUser(user: currentUser!);
      _userService.fetchUser();
    }
    setDeviceData();
    notifyListeners();
  }

  void changeM2(bool isIncrement) {
    if (isIncrement) {
      _deviceData!.m2++;
    } else {
      _deviceData!.m2--;
      currentUser!.balance = currentUser!.balance - 2;
      _firestoreService.updateUser(user: currentUser!);
      _userService.fetchUser();
    }
    setDeviceData();
    notifyListeners();
  }

  ///RTDB======================================================
  DeviceReading? get node => _dbService.node;
  DeviceReading2? get node2 => _dbService.node2;
  void setupDevice() {
    log.i("Setting up listening from robot");
    currentUser = user;
    if (node == null) {
      _dbService.setupNodeListening();
      _dbService.setupNode2Listening();
    }
    //Getting servo angle
    getDeviceData();
  }

  DeviceData? _deviceData;
  DeviceData? get deviceData => _deviceData;

  void setDeviceData() {
    _dbService.setDeviceData(_deviceData!);
  }

  void getDeviceData() async {
    setBusy(true);
    if (user == null) await _userService.fetchUser();
    DeviceData? deviceData = await _dbService.getDeviceData();
    if (deviceData != null) {
      _deviceData = DeviceData(
        stepper1: deviceData.stepper1,
        stepper2: deviceData.stepper2,
        redLed: deviceData.redLed,
        greenLed: deviceData.greenLed,
        buzzer: deviceData.buzzer,
        reset: deviceData.reset,
        m1: deviceData.m1,
        m2: deviceData.m2,
      );
    }
    setBusy(false);
  }

  ///=======================
  bool _isDispensing = false;
  bool get isDispensing => _isDispensing;
  String _status = "";
  String get status => _status;

  bool _isStatus = false;
  bool get isStatus => _isStatus;
  void setStatusView() {
    _isStatus = !_isStatus;
    notifyListeners();
  }

  void dispense(int m) async {
    setReset();
    if (currentUser!.balance < 2) {
      _status = "You balance is low!";
      notifyListeners();
      return;
    }
    _isDispensing = true;
    _status = "Dispensing started..";
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _status = "Enter you pin";
    notifyListeners();
    await Future.delayed(const Duration(seconds: 8));
    if (user!.pin == node2!.pin) {
      _status = "Pin passed";
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      _status = "Scan you RFID";
      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
      if (user!.rfid == node!.rfid) {
        _status = "User verified";
        notifyListeners();
        await Future.delayed(const Duration(seconds: 1));
        rightInput("Dispensing medicine");
        await Future.delayed(const Duration(seconds: 1));
        if (m == 1) {
          setStepper1();
          await Future.delayed(const Duration(seconds: 1));
          setStepper1();
          await Future.delayed(const Duration(seconds: 1));
          changeM1(false);
        } else {
          setStepper2();
          await Future.delayed(const Duration(seconds: 1));
          setStepper2();
          await Future.delayed(const Duration(seconds: 1));
          changeM2(false);
        }
        rightInput("Thank you for visiting!");
        await Future.delayed(const Duration(seconds: 3));
      } else if (node2!.pin.isNotEmpty) {
        await wrongInput("Wrong RFID input, retry");
      } else {
        await wrongInput("No RFID input, Time out!");
      }
    } else if (node2!.pin.isNotEmpty) {
      await wrongInput("Wrong pin, retry");
    } else {
      await wrongInput("No pin input, Time out!");
    }

    _isDispensing = false;
    notifyListeners();
  }

  Future wrongInput(String text) async {
    _status = text;
    setRedLed();
    setBuzzer();
    await Future.delayed(const Duration(seconds: 1));
    setRedLed();
    setBuzzer();
  }

  Future rightInput(String text) async {
    _status = text;
    setGreenLed();
    // await Future.delayed(const Duration(seconds: 1));
    // setGreenLed();
  }

  AppUser? currentUser;
}
