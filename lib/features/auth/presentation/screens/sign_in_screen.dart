import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/util/validations.dart';
import '../../../../core/widgets/loading_wall.dart';
import '../notifiers/auth_notifier.dart';
import '../widgets/social_login_button.dart';

class SignInScreen extends StatelessWidget {
  final AuthNotifierImpl authNotifierImpl;
  final LocalizedStringImpl localizedString;
  final ValidationUtils validationUtils;
  final NotificationsUtils notificationsUtils;
  final AppTheme appTheme;
  final AppNavigator appNavigator;

  SignInScreen({
    Key key,
    @required this.authNotifierImpl,
    @required this.localizedString,
    @required this.validationUtils,
    @required this.notificationsUtils,
    @required this.appTheme,
    @required this.appNavigator,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _getString(String matcher) =>
      localizedString.getLocalizedString(matcher);

  InputDecoration _getInputDecoration(String title) =>
      appTheme.inputDecoration(_getString(title));

  void _gotToSignUpScreen() => GetIt.I<AppNavigator>().push('/signUp');

  Future<void> _signIn() async {
    if (_formKey.currentState.validate()) {
      try {
        await authNotifierImpl.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        appNavigator.pushAndReplace('/home');
      } on ServerFailure catch (failure) {
        notificationsUtils.showErrorNotification(failure.message);
      } on ServerException catch (exception) {
        notificationsUtils.showErrorNotification(exception.message);
      }
    }
  }

  Future<void> _signInWithSocial(SocialLoginType type) async {
    try {
      await authNotifierImpl.signInWithSocial(type);
      appNavigator.pushAndReplace('/home');
    } on ServerFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    } on ServerException catch (exception) {
      notificationsUtils.showErrorNotification(exception.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getString('login-screen.title'))),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/bioverse.png',
                      fit: BoxFit.fill,
                      width: double.infinity,
                      semanticLabel: 'Company Logo',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 32),
                      child: ListBody(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SocialLoginButton(
                                icon: Image.asset(
                                  'assets/google.png',
                                  width: 32,
                                  fit: BoxFit.contain,
                                ),
                                title: _getString(
                                    'login-screen.social-login-google'),
                                onPress: () =>
                                    _signInWithSocial(SocialLoginType.google),
                              ),
                              SizedBox(width: 12),
                              SocialLoginButton(
                                icon: Image.asset(
                                  'assets/facebook.png',
                                  width: 24,
                                  fit: BoxFit.contain,
                                ),
                                title: _getString(
                                    'login-screen.social-login-facebook'),
                                onPress: () =>
                                    _signInWithSocial(SocialLoginType.facebook),
                              ),
                            ],
                          ),
                          Divider(),
                          TextFormField(
                            controller: _emailController,
                            decoration: _getInputDecoration('labels.email'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return _getString('input-validations.required');
                              }

                              if (!validationUtils.validateEmail(value)) {
                                return _getString(
                                    'input-validations.invalid-email');
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
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: _signIn,
                              child: Text(
                                  _getString('login-screen.submit-button')),
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              onPressed: _gotToSignUpScreen,
                              child: Text(
                                  _getString('login-screen.sign-up-button')),
                            ),
                          ),
                        ],
                      ),
                    )
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
