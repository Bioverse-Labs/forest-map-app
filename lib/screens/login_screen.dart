import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:forestMapApp/common/input_decoration.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  void _signInWithGoogle() {}

  void _signInWithFacebook() {}

  void _signInWithEmailAndPassword() {}

  void _goToSignUpScreen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login-screen.title').tr()),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Form(
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
                  decoration: inputDecoration('labels.email'.tr()),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: inputDecoration('labels.password'.tr()),
                  obscureText: true,
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
