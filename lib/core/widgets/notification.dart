import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String? message;
  final Function? onCancel;
  final Color textColor;
  final Color backgroundColor;
  final IconData icon;

  NotificationWidget({
    Key? key,
    this.message,
    this.onCancel,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.icon = Icons.info_outline,
  }) : super(key: key);

  factory NotificationWidget.error(String? message, Function onCancel) {
    return NotificationWidget(
      message: message,
      onCancel: onCancel,
      textColor: Colors.white,
      backgroundColor: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  factory NotificationWidget.success(String message, Function onCancel) {
    return NotificationWidget(
      message: message,
      onCancel: onCancel,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      icon: Icons.check,
    );
  }

  factory NotificationWidget.info(String message, Function onCancel) {
    return NotificationWidget(
      message: message,
      onCancel: onCancel,
      textColor: Colors.black,
      backgroundColor: Colors.white,
      icon: Icons.info_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: backgroundColor,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: textColor),
              SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Text(
                  message!,
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: onCancel as void Function()?,
                child: Icon(Icons.close, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
