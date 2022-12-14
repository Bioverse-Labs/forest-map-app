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
  "members-role-validation": "Organization must have at least one owner",
  "location-permission": {
    "disabled": "Location services are disabled.",
    "denied-permantly": "Location permissions are permantly denied, we cannot request permissions.",
    "denied": "Location permissions are denied"
  },
  "masks": {
    "phone": "(99) 999 99-99"
  },
  "invitation-link": {
    "title": "Welcome to Forest Map",
    "description": "{name} has invited you to be an member"
  },
  "home-drawer": {
    "logout": "Logout"
  },
  "members-role": {
    "owner": "Owner",
    "admin": "Administrator",
    "member": "Member"
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
  "map-screen": {
    "alert-title": "Atention!",
    "alert-description": "To use this feature, wee need access to device location",
    "alert-cancel-button": "Cancel",
    "alert-confirm-button": "Allow Location",
    "location-permission-title": "Please allow location access or enable device GPS",
    "location-permission-button": "Allow/Enable Location",
    "input-label": "Specie/Nome",
    "input-placeholder": "Castanheira",
    "save-button": "Save",
    "post-success": "Data saved!",
    "start-saving": "Data started to being saved"
  },
  "organization-screen": {
    "title": "Organizations",
    "empty-state-title": "Currently you are not assined to any organization... :/",
    "empty-state-button": "New organization",
    "members-counter": "Members",
    "invite-member-button": "Invite Members",
    "invite-member-button-tooltip": "Generate link to invite an User",
    "edit-button": "Edit data",
    "data-section-title": "Tree Locations Data",
    "members-list": "Members"
  },
  "edit-organization-screen": {
    "title": "Edit Organization"
  },
  "profile-screen": {
    "organization-counter": "Organizations",
    "logout-button": "Sign Out"
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
    "update-error": "Ops... ocorreu uma falha durante a atualiza????o de dados",
    "deletion-error": "Ops... ocorreu uma falha durante a remo????o de dados"
  },
  "auth-exceptions": {
    "invalid-email": "Por favor digite um e-mail valido!",
    "user-disabled": "Ops... essa conta est?? temporariamente desativada, por favor entre em contato como nosso suporte.",
    "user-not-found": "Ops... n??o encontramos nenhum conta cadastrada com esse endere??o de email",
    "email-in-use": "Ops.. esse endere??o de email j?? est?? cadastrado em outra conta",
    "wrong-password": "Email ou senha incorretos..."
  },
  "input-validations": {
    "required": "Esse campo ?? obrigat??rio!",
    "invalid-email": "Por favor digite um e-mail valido!",
    "invalid-phone": "Por favor digite um n??mero de celular valido!",
    "invalid-password": "A senha deve conter no m??nimo 8 caracteres"
  },
  "members-role-validation": "A Organiza????o precisa ter ao menos um dono",
  "location-permission": {
    "disabled": "O GPS est?? desativado.",
    "denied-permantly": "As permiss??es de localiza????o do aparelho est??o permanentemente negadas, por favor ative a localiza????o para continuar.",
    "denied": "As permiss??es de localiza????o foram negadas"
  },
  "masks": {
    "phone": "(99) 99999-9999"
  },
  "invitation-link": {
    "title": "Bem-Vindo ao Forest Map",
    "description": "{name} te convidou para fazer parte da equipe!"
  },
  "home-drawer": {
    "logout": "Sair"
  },
  "members-role": {
    "owner": "Dono",
    "admin": "Administrador",
    "member": "Membro"
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
    "title": "Pr?? Visualiza????o",
    "submit-button": "Salvar"
  },
  "map-screen": {
    "alert-title": "Aten????o!",
    "alert-description": "Para utilizar essa funcionalidade, permita o acesso ao GPS do aparelho",
    "alert-cancel-button": "Cancelar",
    "alert-confirm-button": "Permitir Localiza????o",
    "location-permission-title": "Por Favor permita o acesso ao GPS do aparelho",
    "location-permission-button": "Permitir/Habilitar Localiza????o",
    "input-label": "Especie/Nome",
    "input-placeholder": "Castanheira",
    "save-button": "Salvar",
    "post-success": "Dado salvo!",
    "start-saving": "Dado come??ou a ser salvo"
  },
  "organization-screen": {
    "title": "Organiza????es",
    "empty-state-title": "Atualmente voc?? n??o faz parte de nenhum organiza????o :/",
    "empty-state-button": "Nova organiza????o",
    "members-counter": "Membros",
    "invite-member-button": "Convidar membros",
    "invite-member-button-tooltip": "Gera um link para convidar um usu??rio",
    "edit-button": "Editar info",
    "data-section-title": "Localiza????es das ??rvores",
    "members-list": "Membros"
  },
  "edit-organization-screen": {
    "title": "Editar Organiza????o"
  },
  "profile-screen": {
    "organization-counter": "Organiza????es",
    "logout-button": "Sair"
  },
  "home-screen": {
    "map-tab": "Mapa",
    "organization-tab": "Organiza????es",
    "profile-tab": "Perfil"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "pt_BR": pt_BR};
}
