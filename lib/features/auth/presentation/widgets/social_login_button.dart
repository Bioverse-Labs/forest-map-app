import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final Function? onPress;
  final String? title;
  final Widget? icon;

  const SocialLoginButton({
    Key? key,
    this.onPress,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: OutlinedButton(
        onPressed: onPress as void Function()?,
        child: Row(
          children: [
            icon!,
            SizedBox(width: 8),
            Text(title!),
          ],
        ),
      ),
    );
  }
}
