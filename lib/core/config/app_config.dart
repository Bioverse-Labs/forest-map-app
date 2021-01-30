import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forestMapApp/core/style/theme.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_social.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../adapters/firebase_auth_adapter.dart';
import '../adapters/firestore_adapter.dart';
import '../navigation/app_navigator.dart';
import '../platform/camera.dart';
import '../platform/location.dart';
import '../platform/network_info.dart';
import '../util/image.dart';
import '../util/localized_string.dart';
import '../util/notifications.dart';
import '../util/validations.dart';

class AppConfig {
  static Future<void> initEssentialServices() async {
    await Firebase.initializeApp();
    await Hive.initFlutter();
  }

  static void registerHiveAdapters() {
    // * Register all hiver adapters
  }

  static void registerUtils() {
    GetIt.I.registerLazySingleton<LocalizedStringImpl>(
      () => LocalizedStringImpl(),
    );
    GetIt.I.registerLazySingleton<ImageUtilsImpl>(() => ImageUtilsImpl());
    GetIt.I.registerLazySingleton<NotificationsUtils>(
      () => NotificationsUtils(),
    );
    GetIt.I.registerLazySingleton<ValidationUtils>(() => ValidationUtils());
  }

  static void registerPlatformServices() {
    GetIt.I.registerLazySingleton<CameraImpl>(
      () => CameraImpl(
        ImagePicker(),
        GetIt.I<ImageUtils>(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationUtilsImpl>(
      () => LocationUtilsImpl(
        GetIt.I<LocalizedString>(),
      ),
    );

    GetIt.I.registerLazySingleton<NetworkInfoImpl>(
      () => NetworkInfoImpl(
        DataConnectionChecker(),
        Connectivity(),
      ),
    );
  }

  static void registerStyles() {
    GetIt.I.registerLazySingleton<AppTheme>(() => AppTheme());
  }

  static void registerNavigation() {
    GetIt.I.registerLazySingleton<AppNavigator>(() => AppNavigator());
  }

  static void registerAdapters() {
    // * Register all third parties adapters

    GetIt.I.registerLazySingleton<FirebaseAuthAdapterImpl>(
      () => FirebaseAuthAdapterImpl(
        FirebaseAuth.instance,
        GoogleSignIn(),
        FacebookAuth.instance,
        GetIt.I<SocialCredentialAdapterImpl>(),
      ),
    );

    GetIt.I.registerLazySingleton<SocialCredentialAdapterImpl>(
      () => SocialCredentialAdapterImpl(),
    );

    GetIt.I.registerLazySingleton<FirestoreAdapterImpl>(
      () => FirestoreAdapterImpl(
        FirebaseFirestore.instance,
      ),
    );
  }

  // * DATA LAYER SINGLETON'S //

  static void registerDatasources() {
    // * Register all features datasource's

    GetIt.I.registerLazySingleton<AuthRemoteDataSourceImpl>(
      () => AuthRemoteDataSourceImpl(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
      ),
    );
  }

  static void registerRepositories() {
    GetIt.I.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        GetIt.I(),
        GetIt.I(),
      ),
    );
  }

  // * DOMAIN LAYER SINGLETON'S //

  static void registerUseCases() {
    GetIt.I.registerLazySingleton<SignInWithEmailAndPassword>(
      () => SignInWithEmailAndPassword(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<SignInWithSocial>(
      () => SignInWithSocial(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<SignUp>(
      () => SignUp(
        GetIt.I(),
      ),
    );
  }

  // * PRESENTATION LAYER SINGLETON'S //

  static void registerNotifiers() {
    GetIt.I.registerFactory<AuthNotifierImpl>(
      () => AuthNotifierImpl(
        GetIt.I(),
        GetIt.I(),
        GetIt.I(),
      ),
    );
  }
}
