import 'package:flutter/material.dart';
import 'package:medicus_flutter/ui/widgets/meeting_screen.dart';
import 'package:stacked/stacked.dart';

import 'doctor_viewmodel.dart';

class DoctorView extends StackedView<DoctorViewModel> {
  const DoctorView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DoctorViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("Doctor"),),
      body: Column(children: [
        if(!viewModel.isValidMeetingId)
        ElevatedButton(onPressed: viewModel.createMeeting, child: const Text("Create meeting")),
        if(viewModel.isValidMeetingId)
        Expanded(child: MeetingScreen(meetingId: viewModel.meetingId, token: viewModel.sdkToken)) else
          const Text("Not  a valid meeting ID")

      ],),
    );
  }

  @override
  DoctorViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DoctorViewModel();
}
