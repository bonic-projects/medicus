import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/loginRegister.dart';
import 'login_register_viewmodel.dart';

class LoginRegisterView extends StackedView<LoginRegisterViewModel> {
  const LoginRegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginRegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
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
            LoginRegisterWidget(
              onLogin: viewModel.openLoginView,
              onRegister: viewModel.openRegisterView,
              loginText: "Existing User",
              registerText: "New User Register",
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: ElevatedButton(onPressed: viewModel.openDoctorView, child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Doctor's Option"),
              )),
            )
          ],
        ),
      ),
    );
  }

  @override
  LoginRegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginRegisterViewModel();
}
