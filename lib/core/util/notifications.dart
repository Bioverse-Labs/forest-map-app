import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/notification.dart';

class NotificationsUtils {
  void showErrorNotification(
    String? message, {
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
        return NotificationWidget.success(message, cancel);
      },
    );
  }

  void showInfoNotification(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    BotToast.showCustomNotification(
      duration: duration,
      toastBuilder: (cancel) {
        return NotificationWidget.info(message, cancel);
      },
    );
  }

  void showAlertDialog({
    required Widget title,
    required Widget content,
    bool dismissable = true,
    BackButtonBehavior backButtonBehavior = BackButtonBehavior.close,
    List<AlertButtonParams> buttons = const <AlertButtonParams>[],
  }) {
    Widget androidDialog(cancelFunc) => AlertDialog(
          title: title,
          content: content,
          actions: buttons
              .map(
                (button) => button.isPrimary
                    ? ElevatedButton(
                        onPressed: () {
                          cancelFunc();
                          button.action?.call();
                        },
                        child: Text(button.title),
                      )
                    : TextButton(
                        onPressed: () {
                          cancelFunc();
                          button.action?.call();
                        },
                        child: Text(button.title),
                      ),
              )
              .toList(),
        );

    Widget iosDialog(canceFunc) => CupertinoAlertDialog(
          title: title,
          content: content,
          actions: buttons
              .map(
                (button) => button.isPrimary
                    ? CupertinoDialogAction(
                        child: Text(button.title),
                        onPressed: () {
                          canceFunc();
                          button.action?.call();
                        },
                        isDefaultAction: true,
                      )
                    : CupertinoDialogAction(
                        child: Text(button.title),
                        onPressed: () {
                          canceFunc();
                          button.action?.call();
                        },
                      ),
              )
              .toList(),
        );

    BotToast.showAnimationWidget(
      clickClose: dismissable,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      backButtonBehavior: backButtonBehavior,
      animationDuration: const Duration(milliseconds: 400),
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: dismissable ? cancel : null,
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
              animation: controller,
            ),
          ),
          CustomOffsetAnimation(
            controller: controller,
            child: child,
          )
        ],
      ),
      toastBuilder: (cancelFunc) => Platform.isAndroid
          ? androidDialog(cancelFunc)
          : iosDialog(cancelFunc),
    );
  }
}

class AlertButtonParams {
  final String title;
  final VoidCallback? action;
  final bool isPrimary;

  AlertButtonParams({
    required this.title,
    this.action,
    this.isPrimary = false,
  });
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController? controller;
  final Widget? child;

  const CustomOffsetAnimation({Key? key, this.controller, this.child})
      : super(key: key);

  @override
  _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
}

class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  late Tween<Offset> tweenOffset;
  late Tween<double> tweenScale;

  late Animation<double> animation;

  @override
  void initState() {
    tweenOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.8),
      end: Offset.zero,
    );
    tweenScale = Tween<double>(begin: 0.3, end: 1.0);
    animation =
        CurvedAnimation(parent: widget.controller!, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller!,
      builder: (BuildContext context, Widget? child) {
        return FractionalTranslation(
          translation: tweenOffset.evaluate(animation),
          child: ClipRect(
            child: Transform.scale(
              scale: tweenScale.evaluate(animation),
              child: Opacity(
                child: child,
                opacity: animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
