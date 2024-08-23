import 'package:medicus_flutter/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.dialogs.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/appuser.dart';
import '../../../services/user_service.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  // final _bottomSheetService = locator<BottomSheetService>();

  final _userService = locator<UserService>();
  bool get hasUser => _userService.hasLoggedInUser;
  AppUser? get user => _userService.user;

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    setBusy(true);
    // await Future.delayed(const Duration(seconds: 1));
    if (hasUser) {
      if (user == null) {
        await _userService.fetchUser();
      }
      setBusy(false);
    }
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      // description: 'Give stacked $_counter stars on Github',
    );
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }


}
