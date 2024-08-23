import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/appuser.dart';
import '../../../models/device.dart';
import '../../../services/rtdb_service.dart';
import '../../../services/user_service.dart';
import 'register_view.form.dart';

class RegisterViewModel extends FormViewModel {
  final log = getLogger('RegisterViewModel');
  final _userService = locator<UserService>();
  final _dbService = locator<RtdbService>();

  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_dbService];
  DeviceReading? get node => _dbService.node;

  // late String _userRole;
  // String get userRole => _userRole;

  void onModelReady() {
    // _userRole = userRole;
  }

  void registerUser() async {
    if (
        // (_userRole == "doctor" &&
        isFormValid &&
            hasEmail &&
            hasRfid &&
            hasPin &&
            // hasSpecialization &&
            hasPassword &&
            hasName &&
            node?.rfid != ""
        // hasAge &&
        // hasGender
        // ||
        // !hasNameValidationMessage &&
        //     !hasAgeValidationMessage &&
        //     !hasGenderValidationMessage &&
        //     !hasEmailValidationMessage &&
        //     !hasPasswordValidationMessage &&
        //     hasEmail &&
        //     hasPassword &&
        //     hasName &&
        //     hasAge &&
        //     hasGender
        ) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService!.createAccountWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        String? error = await _userService.createUpdateUser(
          AppUser(
            id: result.user!.uid,
            fullName: nameValue!,
            registeredOn: DateTime.now(),
            email: result.user!.email!,
            pin: pinValue!,
            rfid: node!.rfid,
            userRole: "user",
            balance: 100,
            password: passwordValue!,
          ),
        );
        if (error == null) {
          _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
        } else {
          log.i("Firebase error");
          _bottomSheetService.showCustomSheet(
            variant: BottomSheetType.alert,
            title: "Upload Error",
            description: error,
          );
        }
      } else {
        log.i("Error: ${result.errorMessage}");
        _bottomSheetService.showCustomSheet(
          variant: BottomSheetType.alert,
          title: "Error",
          description: result.errorMessage ?? "Enter valid credentials",
        );
      }
    }
    setBusy(false);
  }
}
