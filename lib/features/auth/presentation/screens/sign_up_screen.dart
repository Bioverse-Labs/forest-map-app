import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/util/validations.dart';
import '../../../../core/widgets/screen.dart';
import '../../../organization/presentation/notifiers/organizations_notifier.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../notifiers/auth_notifier.dart';

class SignupScreen extends StatelessWidget {
  final AuthNotifierImpl authNotifierImpl;
  final UserNotifierImpl userNotifierImpl;
  final OrganizationNotifierImpl organizationNotifier;
  final LocalizedString localizedString;
  final ValidationUtils validationUtils;
  final AppTheme appTheme;
  final NotificationsUtils notificationsUtils;
  final AppNavigator appNavigator;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignupScreen({
    Key key,
    @required this.authNotifierImpl,
    @required this.userNotifierImpl,
    @required this.organizationNotifier,
    @required this.localizedString,
    @required this.validationUtils,
    @required this.appTheme,
    @required this.notificationsUtils,
    @required this.appNavigator,
  }) : super(key: key);

  String _getString(String matcher) =>
      localizedString.getLocalizedString(matcher);

  InputDecoration _getInputDecoration(String title) =>
      appTheme.inputDecoration(_getString(title));

  Future<void> _signUp() async {
    if (_formKey.currentState.validate()) {
      try {
        await authNotifierImpl.signUp(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
        );
        await userNotifierImpl.getUser(id: 'currUser', searchLocally: true);
        await organizationNotifier.getOrganization(
          id: 'currOrg',
          searchLocally: true,
        );
        appNavigator.pushAndReplace('/home');
      } on ServerFailure catch (failure) {
        notificationsUtils.showErrorNotification(failure.message);
      } on ServerException catch (exception) {
        notificationsUtils.showErrorNotification(exception.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(title: Text(_getString('signup-screen.title'))),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _getInputDecoration('labels.name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return _getString('input-validations.required');
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: _getInputDecoration('labels.email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return _getString('input-validations.required');
                    }

                    if (!validationUtils.validateEmail(value)) {
                      return _getString('input-validations.invalid-email');
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: _getInputDecoration('labels.password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return _getString('input-validations.required');
                    }

                    if (value.length < 8) {
                      return _getString('input-validations.invalid-password');
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _signUp,
                      child: Text(
                        _getString('signup-screen.submit-button'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      isLoading: Provider.of<AuthNotifierImpl>(context).isLoading,
    );
  }
}
