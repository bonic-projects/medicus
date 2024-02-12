import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/firestore_service.dart';
import '../services/rtdb_service.dart';
import '../services/user_service.dart';
import '../services/videosdk_service.dart';
import '../ui/bottom_sheets/alert/alert_sheet.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/views/doctor/doctor_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/login_register/login_register_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/register/register_view.dart';
import '../ui/views/settings/settings_view.dart';
import '../ui/views/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: LoginRegisterView),
    MaterialRoute(page: DoctorView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: RtdbService),
    LazySingleton(classType: VideosdkService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: AlertSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
