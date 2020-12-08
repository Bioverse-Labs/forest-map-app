import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:forestMapApp/common/input_decoration.dart';
import 'package:forestMapApp/models/user.dart';
import 'package:forestMapApp/utils/validations.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(title: Text('Signup')),
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
                  decoration: inputDecoration('Name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This field is required!';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: inputDecoration('Email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This field is required!';
                    }

                    if (!emailIsValid(value)) {
                      return 'Please input an valid email!';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: inputDecoration('Phone'),
                  inputFormatters: [TextInputMask(mask: '99? (99) 999 99-99')],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This Field is required!';
                    }

                    if (value.length < 17) {
                      return 'Please input an valid phone number!';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: inputDecoration('Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'This field is required!';
                    }

                    if (value.length < 8) {
                      return 'The password must contain at least 8 characters';
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
                      child: Text('Create account'),
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
