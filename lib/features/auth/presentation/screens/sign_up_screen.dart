import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/util/validations.dart';
import '../../../../core/widgets/loading_wall.dart';
import '../notifiers/auth_notifier.dart';

class SignupScreen extends StatelessWidget {
  final AuthNotifierImpl authNotifierImpl;
  final LocalizedStringImpl localizedString;
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
        appNavigator.pushAndReplace('/');
      } on ServerFailure catch (failure) {
        print(failure.stackTrace);
        notificationsUtils.showErrorNotification(failure.message);
      } on ServerException catch (exception) {
        notificationsUtils.showErrorNotification(exception.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getString('signup-screen.title'))),
      body: Stack(
        children: [
          Center(
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
                          return _getString(
                              'input-validations.invalid-password');
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
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
          Consumer<AuthNotifierImpl>(
            builder: (ctx, state, _) {
              if (state.isLoading) {
                return LoadingWall();
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}
