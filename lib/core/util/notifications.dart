import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void showAlertDialog({
    @required BuildContext context,
    @required Widget title,
    @required Widget content,
    List<AlertButtonParams> buttons = const <AlertButtonParams>[],
  }) {
    final androidDialog = AlertDialog(
      title: title,
      content: content,
      actions: buttons
          .map(
            (button) => button.isPrimary
                ? RaisedButton(
                    onPressed: button.action,
                    child: Text(button.title),
                  )
                : FlatButton(
                    onPressed: button.action,
                    child: Text(button.title),
                  ),
          )
          .toList(),
    );

    final iosDialog = CupertinoAlertDialog(
      title: title,
      content: content,
      actions: buttons
          .map(
            (button) => button.isPrimary
                ? CupertinoDialogAction(
                    child: Text(button.title),
                    onPressed: button.action,
                    isDefaultAction: true,
                  )
                : CupertinoDialogAction(
                    child: Text(button.title),
                    onPressed: button.action,
                  ),
          )
          .toList(),
    );

    showDialog(
      context: context,
      builder: (ctx) => Platform.isAndroid ? androidDialog : iosDialog,
      barrierDismissible: false,
    );
  }
}

class AlertButtonParams {
  final String title;
  final Function action;
  final bool isPrimary;

  AlertButtonParams({
    @required this.title,
    @required this.action,
    this.isPrimary = false,
  });
}
