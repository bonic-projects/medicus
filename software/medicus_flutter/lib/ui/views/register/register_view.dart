import 'package:flutter/material.dart';
import 'package:medicus_flutter/ui/smart_widgets/online_status/online_status.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import '../../../constants/validators.dart';
import '../../widgets/customButton.dart';
import 'register_viewmodel.dart';
import 'register_view.form.dart';

@FormView(fields: [
  FormTextField(
    name: 'name',
    validator: FormValidators.validateText,
  ),
  FormTextField(
    name: 'rfid',
    validator: FormValidators.validateRFID,
  ),
  FormTextField(
    name: 'pin',
    validator: FormValidators.validatePin,
  ),
  // FormDropdownField(
  //   name: 'gender',
  //   items: [
  //     StaticDropdownItem(
  //       title: 'Male',
  //       value: 'm',
  //     ),
  //     StaticDropdownItem(
  //       title: 'Female',
  //       value: 'f',
  //     ),
  //     StaticDropdownItem(
  //       title: 'Not specified',
  //       value: 'n',
  //     ),
  //   ],
  // ),
  FormTextField(
    name: 'email',
    validator: FormValidators.validateEmail,
  ),
  FormTextField(
    name: 'password',
    validator: FormValidators.validatePassword,
  ),
])
class RegisterView extends StackedView<RegisterViewModel> with $RegisterView {
  RegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    if(viewModel.node!=null) {
      rfidController.text = viewModel.node?.rfid??"";
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Register'),
        actions: const [Padding(
          padding: EdgeInsets.all(8.0),
          child: IsOnlineWidget(),
        )],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 150,
                ),
              ),
              // const Text(
              //   "Register",
              //   style: TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.w900,
              //   ),
              // ),
              Form(
                // key: F,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                        ),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Full name',
                            errorText: viewModel.nameValidationMessage,
                            errorMaxLines: 2,
                          ),
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          focusNode: nameFocusNode,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                        ),
                        child: TextField(
                          enabled: false,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'RFID',
                            errorText: viewModel.rfidValidationMessage,
                            errorMaxLines: 2,
                          ),
                          controller: rfidController,
                          keyboardType: TextInputType.text,
                          focusNode: rfidFocusNode,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                        ),
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'Pin',
                            errorText: viewModel.pinValidationMessage,
                            errorMaxLines: 2,
                          ),
                          controller: pinController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          focusNode: pinFocusNode,
                        ),
                      ),
                      // const SizedBox(height: 30),
                      //   Column(
                      //     children: [
                      //       ConstrainedBox(
                      //         constraints: const BoxConstraints(
                      //           maxWidth: 350,
                      //         ),
                      //         child: TextField(
                      //           autofocus: true,
                      //           decoration: InputDecoration(
                      //             labelText: 'Specialization',
                      //             errorText:
                      //                 viewModel.specializationValidationMessage,
                      //             errorMaxLines: 2,
                      //           ),
                      //           controller: specializationController,
                      //           keyboardType: TextInputType.text,
                      //           focusNode: specializationFocusNode,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 30),
                      //     ],
                      //   ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     const Text('Select your gender:'),
                      //     const SizedBox(width: 15),
                      //     DropdownButton<String>(
                      //       key: const ValueKey('dropdownField'),
                      //       value: viewModel.genderValue,
                      //       onChanged: (value) {
                      //         viewModel.setGender(value!);
                      //       },
                      //       items: GenderValueToTitleMap.keys
                      //           .map(
                      //             (value) => DropdownMenuItem<String>(
                      //               key: ValueKey('$value key'),
                      //               value: value,
                      //               child: Text(GenderValueToTitleMap[value]!),
                      //             ),
                      //           )
                      //           .toList(),
                      //     )
                      //   ],
                      // ),
                      const SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            errorText: viewModel.emailValidationMessage,
                            errorMaxLines: 2,
                          ),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 350,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            errorText: viewModel.passwordValidationMessage,
                            errorMaxLines: 2,
                          ),
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          focusNode: passwordFocusNode,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        onTap: viewModel.registerUser,
                        text: 'Register',
                        isLoading: viewModel.isBusy,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RegisterViewModel();

  @override
  void onViewModelReady(RegisterViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.onModelReady();
  }

  @override
  void onDispose(RegisterViewModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }
}
