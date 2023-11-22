// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    "labels": {
      "name": "Name",
      "email": "Email",
      "phone": "Phone",
      "password": "Password"
    },
    "no-internet": "You are not connected to the internet",
    "generic-exception": "Ops... something went wrong",
    "database-exceptions": {
      "get-error": "Ops... failed to get data from database",
      "update-error": "Ops... failed to update data in database",
      "deletion-error": "Ops... failed to delete data from database"
    },
    "auth-exceptions": {
      "invalid-email": "Please input an valid email!",
      "user-disabled":
          "Sorry but this user account is disabled, please contact our support",
      "user-not-found":
          "Sorry but we don't have any user with this email address in our base",
      "email-in-use":
          "Sorry but we already have an account registered with this email",
      "wrong-password": "Password or email incorrect"
    },
    "polygon-alert": {"specie-label": "Specie", "date-label": "Date"},
    "input-validations": {
      "required": "This field is required!",
      "invalid-int": "Please input an valid integer!",
      "invalid-email": "Please input an valid email!",
      "invalid-phone": "Please input an valid phone number!",
      "invalid-password": "The password must contain at least 8 characters"
    },
    "members-role-validation": "Organization must have at least one owner",
    "location-permission": {
      "disabled": "Location services are disabled.",
      "denied-permantly":
          "Location permissions are permantly denied, we cannot request permissions.",
      "denied": "Location permissions are denied"
    },
    "masks": {"phone": "(99) 999 99-99"},
    "invitation-link": {
      "title": "Welcome to Forest Map",
      "description": "{name} has invited you to be an member"
    },
    "home-drawer": {"logout": "Logout"},
    "members-role": {
      "owner": "Owner",
      "admin": "Administrator",
      "member": "Member"
    },
    "signup-screen": {"title": "Sign-up", "submit-button": "Create account"},
    "login-screen": {
      "title": "Sign-in",
      "submit-button": "Sign-in",
      "social-login-google": "Sign-in",
      "social-login-facebook": "Sign-in",
      "sign-up-button": "Sign-up",
      "forgot-password-button": "Forgot password?"
    },
    "forgot-password-screen": {
      "title": "Forgot password",
      "description":
          "Please enter your email address and we will send you a link to reset your password",
      "submit-button": "Send email",
      "success-message":
          "We have sent you an email with instructions to reset your password"
    },
    "preview-screen": {"title": "Preview", "submit-button": "Save"},
    "map-screen": {
      "alert-title": "Atention!",
      "alert-description":
          "To use this feature, wee need access to device location",
      "alert-cancel-button": "Cancel",
      "alert-confirm-button": "Allow Location",
      "location-permission-title":
          "Please allow location access or enable device GPS",
      "location-permission-button": "Allow/Enable Location",
      "input-label": "Specie/Nome",
      "input-placeholder": "Castanheira",
      "land-use": {
        "input-label": "Land Use",
        "input-placeholder": "Select land use type",
        "other": "Other land use type"
      },
      "save-button": "Save",
      "example-button": "See Examples",
      "post-success": "Data saved!",
      "start-saving": "Data started to being saved",
      "loading-geolocation-files": "Loading geolocation files...",
      "dbh-label": "DBH",
      "dbh-suffix": "cm",
      "dbh-helper": "Diameter at Breast Height"
    },
    "organization-screen": {
      "title": "Organizations",
      "empty-state-title": "Currently you are not assined to any organization.",
      "empty-state-button": "New organization",
      "members-counter": "Members",
      "invite-member-button": "Invite Members",
      "invite-member-button-tooltip": "Generate link to invite an User",
      "edit-button": "Edit data",
      "data-section-title": "Geolocation Data",
      "members-list": "Members"
    },
    "edit-organization-screen": {"title": "Edit Organization"},
    "organization-invite-screen": {
      "title": "Invite",
      "description": "This Organization has invited you to be member",
      "button": "Accept"
    },
    "profile-screen": {
      "organization-counter": "Organizations",
      "logout-button": "Sign Out"
    },
    "home-screen": {
      "map-tab": "Map",
      "organization-tab": "Organizations",
      "profile-tab": "Profile"
    },
    "ask-location-screen": {
      "title": "Location Permission",
      "description":
          "To accesss app features you need to allow us to collect your location.",
      "body":
          "We need your location to provide precise tree locations around you.",
      "submit-button": "Allow Access"
    }
  };
  static const Map<String, dynamic> pt_BR = {
    "labels": {
      "name": "Nome",
      "email": "E-mail",
      "phone": "Celular",
      "password": "Senha"
    },
    "no-internet": "Você não está conectado na internet",
    "generic-exception": "Ops... alguma coisa deu errado",
    "database-exceptions": {
      "get-error": "Ops... ocorreu uma falha durante a leitura de dados",
      "update-error": "Ops... ocorreu uma falha durante a atualização de dados",
      "deletion-error": "Ops... ocorreu uma falha durante a remoção de dados"
    },
    "auth-exceptions": {
      "invalid-email": "Por favor digite um e-mail valido!",
      "user-disabled":
          "Ops... essa conta está temporariamente desativada, por favor entre em contato como nosso suporte.",
      "user-not-found":
          "Ops... não encontramos nenhum conta cadastrada com esse endereço de email",
      "email-in-use":
          "Ops.. esse endereço de email já está cadastrado em outra conta",
      "wrong-password": "Email ou senha incorretos..."
    },
    "polygon-alert": {"specie-label": "Specie", "date-label": "Date"},
    "input-validations": {
      "required": "Esse campo é obrigatório!",
      "invalid-email": "Por favor digite um e-mail valido!",
      "invalid-int": "Por favor digite um inteiro valido!",
      "invalid-phone": "Por favor digite um número de celular valido!",
      "invalid-password": "A senha deve conter no mínimo 8 caracteres"
    },
    "members-role-validation": "A Organização precisa ter ao menos um dono",
    "location-permission": {
      "disabled": "O GPS está desativado.",
      "denied-permantly":
          "As permissões de localização do aparelho estão permanentemente negadas, por favor ative a localização para continuar.",
      "denied": "As permissões de localização foram negadas"
    },
    "masks": {"phone": "(99) 99999-9999"},
    "invitation-link": {
      "title": "Bem-Vindo ao Forest Map",
      "description": "{name} te convidou para fazer parte da equipe!"
    },
    "home-drawer": {"logout": "Sair"},
    "members-role": {
      "owner": "Dono",
      "admin": "Administrador",
      "member": "Membro"
    },
    "signup-screen": {"title": "Cadastrar", "submit-button": "Criar conta"},
    "login-screen": {
      "title": "Entrar",
      "submit-button": "Entrar",
      "social-login-google": "Entrar",
      "social-login-facebook": "Entrar",
      "sign-up-button": "Cadastre-se aqui",
      "forgot-password-button": "Esqueceu a senha?"
    },
    "forgot-password-screen": {
      "title": "Esqueceu a senha?",
      "description":
          "Digite seu e-mail para enviarmos um link para redefinir sua senha",
      "submit-button": "Enviar",
      "success-message":
          "Um link para redefinir sua senha foi enviado para seu e-mail"
    },
    "preview-screen": {"title": "Pré Visualização", "submit-button": "Salvar"},
    "map-screen": {
      "alert-title": "Atenção!",
      "alert-description":
          "Para utilizar essa funcionalidade, permita o acesso ao GPS do aparelho",
      "alert-cancel-button": "Cancelar",
      "alert-confirm-button": "Permitir Localização",
      "location-permission-title":
          "Por Favor permita o acesso ao GPS do aparelho",
      "location-permission-button": "Permitir/Habilitar Localização",
      "input-label": "Especie/Nome",
      "input-placeholder": "Castanheira",
      "land-use": {
        "input-label": "Uso do terreno",
        "input-placeholder": "Selecione o tipo de uso do terreno",
        "other": "Outro tipo de uso"
      },
      "save-button": "Salvar",
      "example-button": "Ver Exemplos",
      "post-success": "Dado salvo!",
      "start-saving": "Dado começou a ser salvo",
      "loading-geolocation-files":
          "Carregando os arquivos de geolocalização...",
      "dbh-label": "DBH",
      "dbh-suffix": "cm",
      "dbh-helper": "Diâmetro na altura do peito"
    },
    "organization-screen": {
      "title": "Organizações",
      "empty-state-title":
          "Atualmente você não faz parte de nenhum organização.",
      "empty-state-button": "Nova organização",
      "members-counter": "Membros",
      "invite-member-button": "Convidar membros",
      "invite-member-button-tooltip": "Gera um link para convidar um usuário",
      "edit-button": "Editar info",
      "data-section-title": "Dados de geolocalização",
      "members-list": "Membros"
    },
    "edit-organization-screen": {"title": "Editar Organização"},
    "organization-invite-screen": {
      "title": "Convite",
      "description": "Essa organização lhe convidou para ser um membro",
      "button": "Aceitar"
    },
    "profile-screen": {
      "organization-counter": "Organizações",
      "logout-button": "Sair"
    },
    "home-screen": {
      "map-tab": "Mapa",
      "organization-tab": "Organizações",
      "profile-tab": "Perfil"
    },
    "ask-location-screen": {
      "title": "Permissão de Localização",
      "description":
          "Para acessar as funcionalidades do aplicativo precisamos que você habilite o acesso a sua localização",
      "body":
          "Utilizaremos a sua localização para fornecer a localização precisa das árvores ao seu redor.",
      "submit-button": "Permitir Acesso"
    }
  };
  static const Map<String, dynamic> es = {
    "labels": {
      "name": "Nombre",
      "email": "Correo electrónico",
      "phone": "Teléfono",
      "password": "Contraseña"
    },
    "no-internet": "No estás conectado a internet",
    "generic-exception": "Oops... algo salió mal",
    "database-exceptions": {
      "get-error": "Oops... no se pudo obtener datos de la base de datos",
      "update-error": "Oops... no se pudo actualizar datos en la base de datos",
      "deletion-error": "Oops... no se pudo eliminar datos de la base de datos"
    },
    "auth-exceptions": {
      "invalid-email": "¡Por favor, ingresa un correo electrónico válido!",
      "user-disabled":
          "Lo sentimos, pero esta cuenta de usuario está desactivada, por favor, contacta a nuestro soporte",
      "user-not-found":
          "Lo sentimos, pero no tenemos ningún usuario con esta dirección de correo electrónico en nuestra base de datos",
      "email-in-use":
          "Lo sentimos, pero ya tenemos una cuenta registrada con este correo electrónico",
      "wrong-password": "Contraseña o correo electrónico incorrectos"
    },
    "polygon-alert": {"specie-label": "Especie", "date-label": "Fecha"},
    "input-validations": {
      "required": "¡Este campo es obligatorio!",
      "invalid-int": "Por favor, ingresa un número entero válido!",
      "invalid-email": "Por favor, ingresa un correo electrónico válido!",
      "invalid-phone": "Por favor, ingresa un número de teléfono válido!",
      "invalid-password": "La contraseña debe contener al menos 8 caracteres"
    },
    "members-role-validation":
        "La organización debe tener al menos un propietario",
    "location-permission": {
      "disabled": "Los servicios de ubicación están desactivados.",
      "denied-permantly":
          "Los permisos de ubicación están denegados permanentemente, no podemos solicitar permisos.",
      "denied": "Los permisos de ubicación están denegados"
    },
    "masks": {"phone": "(99) 999 99-99"},
    "invitation-link": {
      "title": "Bienvenido a Forest Map",
      "description": "{name} te ha invitado a ser miembro"
    },
    "home-drawer": {"logout": "Cerrar sesión"},
    "members-role": {
      "owner": "Propietario",
      "admin": "Administrador",
      "member": "Miembro"
    },
    "signup-screen": {"title": "Registro", "submit-button": "Crear cuenta"},
    "login-screen": {
      "title": "Inicio de sesión",
      "submit-button": "Iniciar sesión",
      "social-login-google": "Iniciar sesión",
      "social-login-facebook": "Iniciar sesión",
      "sign-up-button": "Registro",
      "forgot-password-button": "¿Olvidaste tu contraseña?"
    },
    "forgot-password-screen": {
      "title": "Olvidé mi contraseña",
      "description":
          "Por favor, ingresa tu dirección de correo electrónico y te enviaremos un enlace para restablecer tu contraseña",
      "submit-button": "Enviar correo electrónico",
      "success-message":
          "Te hemos enviado un correo electrónico con instrucciones para restablecer tu contraseña"
    },
    "preview-screen": {"title": "Vista previa", "submit-button": "Guardar"},
    "map-screen": {
      "alert-title": "¡Atención!",
      "alert-description":
          "Para usar esta función, necesitamos acceder a la ubicación del dispositivo",
      "alert-cancel-button": "Cancelar",
      "alert-confirm-button": "Permitir ubicación",
      "location-permission-title":
          "Por favor, permite el acceso a la ubicación o habilita el GPS del dispositivo",
      "location-permission-button": "Permitir/Habilitar ubicación",
      "input-label": "Especie/Nombre",
      "input-placeholder": "Castanheiro",
      "land-use": {
        "input-label": "Uso de la tierra",
        "input-placeholder": "Selecciona el tipo de uso de la tierra",
        "other": "Otro tipo de uso de la tierra"
      },
      "save-button": "Guardar",
      "example-button": "Ver ejemplos",
      "post-success": "¡Datos guardados!",
      "start-saving": "Comenzando a guardar datos",
      "loading-geolocation-files": "Cargando archivos de geolocalización...",
      "dbh-label": "DAP",
      "dbh-suffix": "cm",
      "dbh-helper": "Diámetro a la altura del pecho"
    },
    "organization-screen": {
      "title": "Organizaciones",
      "empty-state-title":
          "Actualmente no estás asignado a ninguna organización.",
      "empty-state-button": "Nueva organización",
      "members-counter": "Miembros",
      "invite-member-button": "Invitar miembros",
      "invite-member-button-tooltip":
          "Generar enlace para invitar a un usuario",
      "edit-button": "Editar datos",
      "data-section-title": "Datos de geolocalización",
      "members-list": "Miembros"
    },
    "edit-organization-screen": {"title": "Editar organización"},
    "organization-invite-screen": {
      "title": "Invitación",
      "description": "Esta organización te ha invitado a ser miembro",
      "button": "Aceptar"
    },
    "profile-screen": {
      "organization-counter": "Organizaciones",
      "logout-button": "Cerrar sesión"
    },
    "home-screen": {
      "map-tab": "Mapa",
      "organization-tab": "Organizaciones",
      "profile-tab": "Perfil"
    },
    "ask-location-screen": {
      "title": "Permiso de ubicación",
      "description":
          "Para acceder a las funciones de la aplicación, debes permitirnos recopilar tu ubicación.",
      "body":
          "Necesitamos tu ubicación para proporcionar ubicaciones precisas de árboles a tu alrededor.",
      "submit-button": "Permitir acceso"
    }
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "pt_BR": pt_BR,
    "es": es
  };
}
