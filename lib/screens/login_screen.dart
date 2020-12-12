import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forestMapApp/common/input_decoration.dart';
import 'package:forestMapApp/notifiers/user_notifier.dart';
import 'package:forestMapApp/screens/signup_screen.dart';
import 'package:forestMapApp/utils/app_navigator.dart';
import 'package:forestMapApp/utils/validations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserNotifier _userNotifier;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);
  }

  void _signInWithGoogle() => _userNotifier.signInWithGoogle();

  void _signInWithFacebook() => _userNotifier.signInWithFacebook();

  void _signInWithEmailAndPassword() {
    if (_formKey.currentState.validate()) {
      _userNotifier.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  void _goToSignUpScreen() =>
      GetIt.I<AppNavigator>().pushWidget(SignupScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login-screen.title').tr()),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: OutlineButton(
                        onPressed: _signInWithGoogle,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/google.png',
                              width: 32,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8),
                            Text('login-screen.social-login-google').tr(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      flex: 1,
                      child: OutlineButton(
                        onPressed: _signInWithFacebook,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/facebook.png',
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8),
                            Text('login-screen.social-login-facebook').tr(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration('labels.email'.tr()),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'input-validations.required'.tr();
                    }

                    if (!emailIsValid(value)) {
                      return 'input-validations.invalid-email'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: inputDecoration('labels.password'.tr()),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'input-validations.required'.tr();
                    }

                    if (value.length < 8) {
                      return 'input-validations.invalid-password'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: _signInWithEmailAndPassword,
                    child: Text('login-screen.submit-button').tr(),
                  ),
                ),
                Divider(),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    onPressed: _goToSignUpScreen,
                    child: Text('login-screen.sign-up-button').tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
