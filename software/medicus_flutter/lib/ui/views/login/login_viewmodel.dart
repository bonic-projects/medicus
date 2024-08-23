import 'dart:async';

import 'package:medicus_flutter/models/appuser.dart';
import 'package:medicus_flutter/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/device.dart';
import '../../../services/firestore_service.dart';
import '../../../services/rtdb_service.dart';
import 'login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');
  final _dbService = locator<RtdbService>();
  final _firestoreService = locator<FirestoreService>();
  final _userService = locator<UserService>();


  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_dbService];
  DeviceReading? get node => _dbService.node;

  late Timer _timer;

  void onModelReady() {
    startTimer();
  }

  bool _isRfidRead = false;
  bool get isRfidRead => _isRfidRead;

  String? rfid;

  AppUser? user;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      log.i(node!.rfid);
      if(node!=null && node!.rfid!="" && node!.rfid.length == 8){
        log.i("RFID got");
        _isRfidRead = true;
        rfid = node!.rfid;
        notifyListeners();
        if(user == null){
          setBusy(true);
          user = await _firestoreService.getUserFromRfid(rfid: rfid!);
          notifyListeners();
          if(user!=null) {
            await authenticateUser(user!);
          }
          setBusy(false);
        }
      }
      // log.i('Timer tick');
    });
  }



  Future authenticateUser(AppUser user) async {
    // if (isFormValid && emailValue != null && passwordValue != null) {
      // log.i("email and pass valid");
      // log.i(emailValue!);
      // log.i(passwordValue!);

      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService!.loginWithEmail(
        email: user.email,
        password: user.password,
      );
      if (result.user != null) {
        _userService.fetchUser();
        _timer.cancel();
          _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
      } else {
        log.i("Error: ${result.errorMessage}");
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.alert,
          title: "Error",
          description: result.errorMessage ?? "Enter valid credentials",
        );
      }
    // }
  }


  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the ViewModel is disposed
    super.dispose();
  }

}
