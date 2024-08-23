import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

import '../../smart_widgets/device_control/device_control.dart';
import '../../smart_widgets/online_status/online_status.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Medicine Dispenser'),
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: IsOnlineWidget(),
            ),
            // if (viewModel.user != null)
            //   IconButton(
            //     onPressed: viewModel.logout,
            //     icon: const Icon(Icons.logout),
            //   ),
          ],
        ),
        body: const DeviceControlView(isUser: true));
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
