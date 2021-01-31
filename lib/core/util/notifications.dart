import 'package:bot_toast/bot_toast.dart';

import '../widgets/notification.dart';

class NotificationsUtils {
  void showErrorNotification(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    BotToast.showCustomNotification(
      duration: duration,
      toastBuilder: (cancel) {
        return NotificationWidget.error(message, cancel);
      },
    );
  }

  void showSuccessNotification(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    BotToast.showCustomNotification(
      duration: duration,
      toastBuilder: (cancel) {
        return NotificationWidget.error(message, cancel);
      },
    );
  }
}
