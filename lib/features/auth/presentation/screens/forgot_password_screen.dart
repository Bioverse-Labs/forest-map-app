import 'package:flutter/material.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/style/theme.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/util/validations.dart';
import '../../../../core/widgets/screen.dart';
import '../notifiers/auth_notifier.dart';
import 'package:provider/provider.dart';

class ForgotPassworScreen extends StatelessWidget {
  final AuthNotifierImpl authNotifier;
  final LocalizedString localizedString;
  final AppTheme appTheme;
  final ValidationUtils validationUtils;
  final NotificationsUtils notificationsUtils;
  final AppNavigator appNavigator;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputCtr = TextEditingController();

  ForgotPassworScreen({
    Key key,
    this.authNotifier,
    this.localizedString,
    this.appTheme,
    this.validationUtils,
    this.notificationsUtils,
    this.appNavigator,
  }) : super(key: key);

  Future<void> _onSubmit() async {
    if (_formKey.currentState.validate()) {
      try {
        await authNotifier.forgotPassword(_inputCtr.text);

        notificationsUtils.showSuccessNotification(localizedString
            .getLocalizedString('forgot-password-screen.success-message'));

        appNavigator.pop();
      } catch (error) {
        if (error is ServerFailure) {
          notificationsUtils.showErrorNotification(error.message);
        } else {
          notificationsUtils.showErrorNotification(error.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifierImpl>(builder: (context, state, _) {
      return ScreenWidget(
        isLoading: state.isLoading,
        appBar: AppBar(
          title: Text(
            localizedString.getLocalizedString('forgot-password-screen.title'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Text(
                localizedString
                    .getLocalizedString('forgot-password-screen.description'),
                style: Theme.of(context).textTheme.headline5,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _inputCtr,
                  decoration: appTheme.inputDecoration('Email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return localizedString
                          .getLocalizedString('input-validations.required');
                    }

                    if (!validationUtils.validateEmail(value)) {
                      return localizedString.getLocalizedString(
                          'input-validations.invalid-email');
                    }

                    return null;
                  },
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: Text(
                    localizedString.getLocalizedString(
                        'forgot-password-screen.submit-button'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
