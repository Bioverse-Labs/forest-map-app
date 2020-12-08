import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/common/input_decoration.dart';
import 'package:forestMapApp/models/user.dart';
import 'package:forestMapApp/utils/validations.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignupScreen({Key key}) : super(key: key);

  void _handleFormSubmit(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Provider.of<UserModel>(context, listen: false)
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _phoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('signup-screen.title').tr()),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: inputDecoration('labels.name'.tr()),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'input-validations.required'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration('labels.email'.tr()),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'input-validations.required'.tr();
                    }

                    if (!emailIsValid(value)) {
                      return 'input-validations.invalid-email'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: inputDecoration('labels.phone'.tr()),
                  inputFormatters: [TextInputMask(mask: 'masks.phone'.tr())],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'input-validations.required'.tr();
                    }

                    if (value.length < 4) {
                      return 'input-validations.invalid-phone'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: inputDecoration('labels.password'.tr()),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'input-validations.required'.tr();
                    }

                    if (value.length < 8) {
                      return 'input-validations.invalid-password'.tr();
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      onPressed: () => _handleFormSubmit(context),
                      child: Text('signup-screen.submit-button').tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
