import 'dart:async';

import 'package:medicus_flutter/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../models/device.dart';
import '../../../services/firestore_service.dart';
import '../../../services/rtdb_service.dart';
import '../../../services/user_service.dart';
import '../../../services/videosdk_service.dart';

class DeviceControlViewModel extends ReactiveViewModel {
  final log = getLogger('DeviceControlWidget');
  final _dbService = locator<RtdbService>();
  final _userService = locator<UserService>();
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();

  AppUser? get user => _userService.user;

  @override
  List<ListenableServiceMixin> get listenableServices => [_dbService];

  void logout() async {
    setContent("del");
    await Future.delayed(const Duration(milliseconds: 100));
    setContent("");
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  final _videosdkService = locator<VideosdkService>();
  void openDoctorView() async {
    setBusy(true);
    String? m = await _videosdkService.createMeeting();
    if(m!=null) {
      log.i(m);
      setContent(m);
      await Future.delayed(const Duration(seconds: 1));
      setBusy(false);
      _navigationService.navigateToDoctorView( isUser: true);
    }
  }

  Future setOpen1()async  {
    _deviceData!.isOpen1 = true;
    setDeviceData();
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    _deviceData!.isOpen1 = false;
    setDeviceData();
    notifyListeners();
  }
  Future setOpen2()async  {
    _deviceData!.isOpen2 = true;
    setDeviceData();
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    _deviceData!.isOpen2 = false;
    setDeviceData();
    notifyListeners();
  }
  Future setOpen3()async  {
    _deviceData!.isOpen3 = true;
    setDeviceData();
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1000));
    _deviceData!.isOpen3 = false;
    setDeviceData();
    notifyListeners();
  }

  void setContent(String value) {
    _deviceData!.content = value;
    setDeviceData();
    notifyListeners();
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

  void changeM3(bool isIncrement) {
    if (isIncrement) {
      _deviceData!.m3++;
    } else {
      _deviceData!.m3--;
      currentUser!.balance = currentUser!.balance - 2;
      _firestoreService.updateUser(user: currentUser!);
      _userService.fetchUser();
    }
    setDeviceData();
    notifyListeners();
  }

  ///RTDB======================================================
  DeviceReading? get node => _dbService.node;
  void setupDevice() {
    log.i("Setting up listening from device");
    currentUser = user;
    if (node == null) {
      _dbService.setupNodeListening();
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
        isOpen1: deviceData.isOpen1,
        isOpen2: deviceData.isOpen2,
        isOpen3: deviceData.isOpen3,
        m1: deviceData.m1,
        m2: deviceData.m2,
        m3: deviceData.m3,
        content: deviceData.content,
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
    currentUser ??= user;
    log.e("dis");
    if (currentUser!=null && currentUser!.balance < 2) {
      _status = "You balance is low!";
      notifyListeners();
      return;
    }


    _isDispensing = true;
    _status = "Dispensing started..";
    notifyListeners();

    if(m == 1) {
      await setOpen1();
      changeM1(false);
    } else   if(m == 2) {
      await setOpen2();
      changeM2(false);
    } else   if(m == 3) {
      await setOpen3();
      changeM3(false);
    }

    _isDispensing = false;
    _status = "Medicine dispensed";
    notifyListeners();
  }

  AppUser? currentUser;
}
