// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "labels": {
    "name": "Name",
    "email": "Email",
    "phone": "Phone",
    "password": "Password"
  },
  "input-validations": {
    "required": "This field is required!",
    "invalid-email": "Please input an valid email!",
    "invalid-phone": "Please input an valid phone number!",
    "invalid-password": "The password must contain at least 8 characters"
  },
  "masks": {
    "phone": "(99) 999 99-99"
  },
  "home-drawer": {
    "logout": "Logout"
  },
  "signup-screen": {
    "title": "Sign-up",
    "submit-button": "Create account"
  },
  "login-screen": {
    "title": "Sign-in",
    "submit-button": "Sign-in",
    "social-login-google": "Sign-in",
    "social-login-facebook": "Sign-in",
    "sign-up-button": "Or Sign-up here"
  }
};
static const Map<String,dynamic> pt_BR = {
  "labels": {
    "name": "Nome",
    "email": "E-mail",
    "phone": "Celular",
    "password": "Senha"
  },
  "input-validations": {
    "required": "Esse campo é obrigatório!",
    "invalid-email": "Por favor digite um e-mail valido!",
    "invalid-phone": "Por favor digite um número de celular valido!",
    "invalid-password": "A senha deve conter no mínimo 8 caracteres"
  },
  "masks": {
    "phone": "(99) 99999-9999"
  },
  "home-drawer": {
    "logout": "Sair"
  },
  "signup-screen": {
    "title": "Cadastrar",
    "submit-button": "Criar conta"
  },
  "login-screen": {
    "title": "Entrar",
    "submit-button": "Entrar",
    "social-login-google": "Entrar",
    "social-login-facebook": "Entrar",
    "sign-up-button": "Ou Cadastre-se aqui"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "pt_BR": pt_BR};
}
