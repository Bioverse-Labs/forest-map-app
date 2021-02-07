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
  "generic-exception": "Ops... something went wrong",
  "database-exceptions": {
    "get-error": "Ops... failed to get data from database",
    "update-error": "Ops... failed to update data in database",
    "deletion-error": "Ops... failed to delete data from database"
  },
  "auth-exceptions": {
    "invalid-email": "Please input an valid email!",
    "user-disabled": "Sorry but this user account is disabled, please contact our support",
    "user-not-found": "Sorry but we don't have any user with this email address in our base",
    "email-in-use": "Sorry but we already have an account registered with this email",
    "wrong-password": "Password or email incorrect"
  },
  "input-validations": {
    "required": "This field is required!",
    "invalid-email": "Please input an valid email!",
    "invalid-phone": "Please input an valid phone number!",
    "invalid-password": "The password must contain at least 8 characters"
  },
  "location-permission": {
    "disabled": "Location services are disabled.",
    "denied-permantly": "Location permissions are permantly denied, we cannot request permissions.",
    "denied": "Location permissions are denied"
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
  },
  "preview-screen": {
    "title": "Preview",
    "submit-button": "Save"
  },
  "map-screen": {},
  "organization-screen": {
    "title": "Organizations",
    "empty-state-title": "Currently you are not assined to any organization... :/",
    "empty-state-button": "New organization",
    "members-counter": "Members",
    "invite-member-button": "Invite Members",
    "invite-member-button-tooltip": "Generate link to invite an User",
    "edit-button": "Edit data",
    "data-section-title": "Tree Locations Data"
  },
  "edit-organization-screen": {
    "title": "Edit Organization"
  },
  "home-screen": {
    "map-tab": "Map",
    "organization-tab": "Organizations",
    "profile-tab": "Profile"
  }
};
static const Map<String,dynamic> pt_BR = {
  "labels": {
    "name": "Nome",
    "email": "E-mail",
    "phone": "Celular",
    "password": "Senha"
  },
  "generic-exception": "Ops... alguma coisa deu errado",
  "database-exceptions": {
    "get-error": "Ops... ocorreu uma falha durante a leitura de dados",
    "update-error": "Ops... ocorreu uma falha durante a atualização de dados",
    "deletion-error": "Ops... ocorreu uma falha durante a remoção de dados"
  },
  "auth-exceptions": {
    "invalid-email": "Por favor digite um e-mail valido!",
    "user-disabled": "Ops... essa conta está temporariamente desativada, por favor entre em contato como nosso suporte.",
    "user-not-found": "Ops... não encontramos nenhum conta cadastrada com esse endereço de email",
    "email-in-use": "Ops.. esse endereço de email já está cadastrado em outra conta",
    "wrong-password": "Email ou senha incorretos..."
  },
  "input-validations": {
    "required": "Esse campo é obrigatório!",
    "invalid-email": "Por favor digite um e-mail valido!",
    "invalid-phone": "Por favor digite um número de celular valido!",
    "invalid-password": "A senha deve conter no mínimo 8 caracteres"
  },
  "location-permission": {
    "disabled": "O GPS está desativado.",
    "denied-permantly": "As permissões de localização do aparelho estão permanentemente negadas, por favor ative a localização para continuar.",
    "denied": "As permissões de localização foram negadas"
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
  },
  "preview-screen": {
    "title": "Pré Visualização",
    "submit-button": "Salvar"
  },
  "map-screen": {},
  "organization-screen": {
    "title": "Organizações",
    "empty-state-title": "Atualmente você não faz parte de nenhum organização :/",
    "empty-state-button": "Nova organização",
    "members-counter": "Membros",
    "invite-member-button": "Convidar membros",
    "invite-member-button-tooltip": "Gera um link para convidar um usuário",
    "edit-button": "Editar info",
    "data-section-title": "Localizações das árvores"
  },
  "edit-organization-screen": {
    "title": "Editar Organização"
  },
  "home-screen": {
    "map-tab": "Mapa",
    "organization-tab": "Organizações",
    "profile-tab": "Perfil"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "pt_BR": pt_BR};
}
