import 'package:flutter/material.dart';
import 'package:medicus_flutter/ui/smart_widgets/device_control/device_control.dart';
import 'package:medicus_flutter/ui/widgets/meeting_screen.dart';
import 'package:stacked/stacked.dart';

import 'doctor_viewmodel.dart';

class DoctorView extends StackedView<DoctorViewModel> {
  final bool isUser;
  const DoctorView({Key? key, required this.isUser}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DoctorViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title:  Text(isUser ? "User: Meeting" :"Doctor: Meeting"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        if(viewModel.isValidMeetingId)
          Expanded(child: MeetingScreen(meetingId: viewModel.meetingId, token: viewModel.sdkToken)) else
          const Expanded(child: Center(child: Text("No meetings are available now"))),

          // if(viewModel.isValidMeetingId && !isUser)
            const Expanded(child: Column(
              children: [
                SizedBox(height: 100),
                Expanded(child: DeviceControlView(isUser: false)),
              ],
            ))

      ],),
    );
  }

  @override
  DoctorViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DoctorViewModel();

  @override
  void onViewModelReady(DoctorViewModel viewModel) {
    viewModel.onModelReady(isUser);
    super.onViewModelReady(viewModel);
  }
}
