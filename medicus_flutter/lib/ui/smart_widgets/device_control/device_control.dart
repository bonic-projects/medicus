import 'package:at_viz/at_gauges/radial_gauges/simple_radial_gauge.dart';
import 'package:at_viz/at_gauges/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/customButton.dart';
import 'device_control_viewmodel.dart';

class DeviceControlView extends StackedView<DeviceControlViewModel> {
  final bool isUser;
  const DeviceControlView({Key? key, required this.isUser}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DeviceControlViewModel viewModel,
    Widget? child,
  ) {
    // if (viewModel.node != null &&
    //     viewModel.node2 != null &&
    //     viewModel.deviceData != null &&
    //     viewModel.user != null) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          if(isUser)
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: ElevatedButton(onPressed: viewModel.logout, child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Logout"),
            )),
          ),
          if(isUser)
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: ElevatedButton(onPressed:

            viewModel.isBusy ? null :  viewModel.openDoctorView,

                child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(viewModel.isBusy  ? "Loading.." : "Start Meeting with doctor"),
            )),
          ),

          if(isUser && viewModel.currentUser!=null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Balance: ₹${viewModel.currentUser!.balance}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
              ),
            ),
          ),
          // if (!viewModel.isDispensing)

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            SimpleRadialGauge(
              actualValue: (viewModel.node?.heartRate?? 0).toDouble(),
              maxValue: 100,
              minValue: 0,
              title: const Text('Heart Rate'),
              titlePosition: TitlePosition.top,
              unit: 'bpm',
              icon: const Icon(Icons.monitor_heart),
              pointerColor: Colors.red,
              decimalPlaces: 0,
              isAnimate: true,
              animationDuration: 2000,
              size: 190,
            ),
            SimpleRadialGauge(
              actualValue: (viewModel.node?.temp?? 0.0),
              maxValue: 100,
              minValue: 0,
              title: const Text('Temperature'),
              titlePosition: TitlePosition.top,
              unit: 'ºC',
              icon: const Icon(Icons.thermostat_outlined),
              pointerColor: Colors.blue,
              decimalPlaces: 0,
              isAnimate: true,
              animationDuration: 2000,
              size: 190,
            ),
          ],),

          if(viewModel.deviceData!=null)
          Card(
            child: Column(
              children: [
                CustomButton(
                    onTap: () {
                      viewModel.dispense(1);
                    },
                    text:
                        "Dispense medicine 1 | Available: ${viewModel.deviceData!.m1}",
                    isLoading: viewModel.isDispensing),
                CustomButton(
                    onTap: () {
                      viewModel.dispense(2);
                    },
                    text:
                        "Dispense medicine 2 | Available: ${viewModel.deviceData!.m2}",
                    isLoading: viewModel.isDispensing),
                CustomButton(
                    onTap: () {
                      viewModel.dispense(3);
                    },
                    text:
                        "Dispense medicine 3 | Available: ${viewModel.deviceData!.m3}",
                    isLoading: viewModel.isDispensing),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CustomButton(
          //       onTap: viewModel.setStatusView,
          //       text: viewModel.isStatus ? "Hide status" : "Show status",
          //       isLoading: false),
          // ),
          // if (viewModel.isStatus || viewModel.isDispensing)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Status: ${viewModel.status}",
                      style:
                          const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("RFID scanned: ${viewModel.node!.rfid}"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.8),
          Card(
            // color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const Padding(
                //   padding: EdgeInsets.only(top: 16.0),
                //   child: Text(
                //     "Manual Controller",
                //     textAlign: TextAlign.left,
                //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                //   ),
                // ),
                if(viewModel.deviceData!=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                          onTap: viewModel.setOpen1,
                          text:
                              "${!viewModel.deviceData!.isOpen1 ? "Rotate" : "Stop"} Medicine 1",
                          isLoading: false),
                      CustomButton(
                          onTap: viewModel.setOpen2,
                          text:
                              "${!viewModel.deviceData!.isOpen2 ? "Rotate" : "Stop"} Medicine 2",
                          isLoading: false),
                      CustomButton(
                          onTap: viewModel.setOpen3,
                          text:
                              "${!viewModel.deviceData!.isOpen3 ? "Rotate" : "Stop"} Medicine 3",
                          isLoading: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // else {
  //   return const Center(child: CircularProgressIndicator());
  // }
  // }

  @override
  DeviceControlViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DeviceControlViewModel();

  @override
  void onViewModelReady(DeviceControlViewModel viewModel) =>
      viewModel.setupDevice();
}
