import 'package:bot_toast/bot_toast.dart';
import 'package:forestMapApp/common/notification.dart';

class Notifications {
  static void showErrorNotification(
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

  static void showSuccessNotification(
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
