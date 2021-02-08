import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/enums/social_login_types.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/util/validations.dart';
import '../../../../core/widgets/screen.dart';
import '../../../organization/data/hive/organization.dart';
import '../../../organization/data/models/organization_model.dart';
import '../../../organization/presentation/notifiers/organizations_notifier.dart';
import '../../../user/presentation/notifiers/user_notifier.dart';
import '../notifiers/auth_notifier.dart';
import '../widgets/social_login_button.dart';

class SignInScreen extends StatefulWidget {
  final AuthNotifierImpl authNotifier;
  final UserNotifierImpl userNotifier;
  final OrganizationNotifierImpl organizationNotifier;
  final HiveAdapter<OrganizationHive> orgHive;
  final LocalizedString localizedString;
  final ValidationUtils validationUtils;
  final NotificationsUtils notificationsUtils;
  final AppTheme appTheme;
  final AppNavigator appNavigator;

  SignInScreen({
    Key key,
    @required this.authNotifier,
    @required this.userNotifier,
    @required this.organizationNotifier,
    @required this.orgHive,
    @required this.localizedString,
    @required this.validationUtils,
    @required this.notificationsUtils,
    @required this.appTheme,
    @required this.appNavigator,
  }) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  String _getString(String matcher) =>
      widget.localizedString.getLocalizedString(matcher);

  InputDecoration _getInputDecoration(String title) =>
      widget.appTheme.inputDecoration(_getString(title));

  void _gotToSignUpScreen() => GetIt.I<AppNavigator>().push('/signUp');

  Future<void> _signIn() async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final result = await widget.authNotifier.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        final hiveOrg = await widget.orgHive.get('currOrg');
        if (hiveOrg != null) {
          widget.organizationNotifier
              .setOrganization(OrganizationModel.fromHive(hiveOrg));
        }

        await widget.userNotifier.getUser(result.id);
        widget.appNavigator.pushAndReplace('/home');
      } on ServerFailure catch (failure) {
        widget.notificationsUtils.showErrorNotification(failure.message);
      } on ServerException catch (exception) {
        widget.notificationsUtils.showErrorNotification(exception.message);
      } on LocalFailure catch (failure) {
        widget.notificationsUtils.showErrorNotification(failure.message);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithSocial(SocialLoginType type) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final result = await widget.authNotifier.signInWithSocial(type);

      final hiveOrg = await widget.orgHive.get('currOrg');
      if (hiveOrg != null) {
        widget.organizationNotifier
            .setOrganization(OrganizationModel.fromHive(hiveOrg));
      }

      await widget.userNotifier.getUser(result.id);
      widget.appNavigator.pushAndReplace('/home');
    } on ServerFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    } on ServerException catch (exception) {
      widget.notificationsUtils.showErrorNotification(exception.message);
    } on LocalFailure catch (failure) {
      widget.notificationsUtils.showErrorNotification(failure.message);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(title: Text(_getString('login-screen.title'))),
      body: Center(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
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
                            title:
                                _getString('login-screen.social-login-google'),
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

                          if (!widget.validationUtils.validateEmail(value)) {
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
                          child: Text(_getString('login-screen.submit-button')),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: _gotToSignUpScreen,
                          child:
                              Text(_getString('login-screen.sign-up-button')),
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
      isLoading: _isLoading,
    );
  }
}
