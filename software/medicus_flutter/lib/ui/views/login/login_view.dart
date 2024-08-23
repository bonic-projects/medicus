import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medicus_flutter/ui/smart_widgets/online_status/online_status.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../../constants/validators.dart';
import '../../widgets/customButton.dart';
import 'login_view.form.dart';
import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(
    name: 'pin',
    validator: FormValidators.validatePin,
  )
])
class LoginView extends StackedView<LoginViewModel> with $LoginView {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Login'),
        actions: const [Padding(
          padding: EdgeInsets.all(8.0),
          child: IsOnlineWidget(),
        )],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                ),
              ),
              if(!viewModel.isRfidRead)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Scan you RFID card",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Lottie.asset("assets/lottie/login.json")
                ],
              ) else if(viewModel.user!=null)
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                      "Welcome: ${viewModel.user!.fullName}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                     ),
                     Lottie.asset("assets/lottie/users.json"),
                     const Text(
                       "Loading..",
                     ),
                   ],
                 ) else if(!viewModel.isBusy)
                const Text(
                  "Invalid Card/Not registered",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ) else  const Center(child: CircularProgressIndicator())

              // Form(
              //   // key: F,
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       children: [
              //         const SizedBox(height: 30),
              //         ConstrainedBox(
              //           constraints: const BoxConstraints(
              //             maxWidth: 350,
              //           ),
              //           child: TextField(
              //             autofocus: true,
              //             decoration: InputDecoration(
              //               labelText: 'Email',
              //               errorText: viewModel.emailValidationMessage,
              //               errorMaxLines: 2,
              //             ),
              //             controller: emailController,
              //             keyboardType: TextInputType.emailAddress,
              //             focusNode: emailFocusNode,
              //           ),
              //         ),
              //         const SizedBox(height: 20),
              //         CustomButton(
              //           onTap: viewModel.authenticateUser,
              //           text: 'Login',
              //           isLoading: viewModel.isBusy,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();

  @override
  void onViewModelReady(LoginViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.onModelReady();
  }

  @override
  void onDispose(LoginViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}
