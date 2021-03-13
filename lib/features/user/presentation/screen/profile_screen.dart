import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/notifiers/home_screen_notifier.dart';
import '../../../../core/platform/camera.dart';
import '../../../../core/util/localized_string.dart';
import '../../../../core/util/notifications.dart';
import '../../../../core/widgets/screen.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../widgets/user_info.dart';

class ProfileScreen extends StatelessWidget {
  final AuthNotifierImpl authNotifier;
  final UserNotifierImpl userNotifier;
  final HomeScreenNotifierImpl homeScreenNotifierImpl;
  final AppNavigator appNavigator;
  final NotificationsUtils notificationsUtils;
  final LocalizedString localizedString;
  final Camera camera;

  const ProfileScreen({
    Key key,
    @required this.authNotifier,
    @required this.homeScreenNotifierImpl,
    @required this.appNavigator,
    @required this.notificationsUtils,
    @required this.userNotifier,
    @required this.localizedString,
    @required this.camera,
  }) : super(key: key);

  void _signOut() {
    try {
      authNotifier.signOut();
      appNavigator.pushAndReplace('/');
      homeScreenNotifierImpl.setActiveTab(0);
    } on ServerFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    } on LocalFailure catch (failure) {
      notificationsUtils.showErrorNotification(failure.message);
    }
  }

  Future<void> _updateAvatar() async {
    final failureOrCameraResp = await camera.takePicture();

    failureOrCameraResp.fold(
      (failure) {
        if (!(failure is CameraCancelFailure)) {
          notificationsUtils.showErrorNotification(
            localizedString.getLocalizedString('generic-exception'),
          );
        }
      },
      (resp) async {
        try {
          await userNotifier.updateUser(
            id: userNotifier.user.id,
            avatar: resp.file,
          );
        } on ServerFailure catch (failure) {
          notificationsUtils.showErrorNotification(failure.message);
        } on LocalFailure catch (failure) {
          notificationsUtils.showErrorNotification(failure.message);
        } on NoInternetFailure catch (_) {
          notificationsUtils.showErrorNotification(
            localizedString.getLocalizedString('no-internet'),
          );
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return ScreenWidget(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<UserNotifierImpl>(
                  builder: (ctx, state, _) {
                    return UserInfo(
                      user: state.user,
                      localizedString: localizedString,
                      onAvatarPress: _updateAvatar,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 32,
          right: 32,
          bottom: 16,
          child: ElevatedButton(
            onPressed: _signOut,
            child: Text(localizedString.getLocalizedString(
              'profile-screen.logout-button',
            )),
          ),
        )
      ],
      isLoading: Provider.of<UserNotifierImpl>(context).isLoading,
    );
  }
}
