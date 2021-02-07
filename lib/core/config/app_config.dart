import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:forestMapApp/features/user/data/datasource/user_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_social.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/organization/data/datasources/organization_data_source.dart';
import '../../features/organization/data/repositories/organization_repository_impl.dart';
import '../../features/organization/domain/repositories/organization_repository.dart';
import '../../features/organization/domain/usecases/create_organization.dart';
import '../../features/organization/domain/usecases/delete_organization.dart';
import '../../features/organization/domain/usecases/get_organization.dart';
import '../../features/organization/domain/usecases/remove_member.dart';
import '../../features/organization/domain/usecases/update_member.dart';
import '../../features/organization/domain/usecases/update_organization.dart';
import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/tracking/data/datasources/location_data_source.dart';
import '../../features/tracking/data/repositories/location_repository_impl.dart';
import '../../features/tracking/domain/repositories/location_repository.dart';
import '../../features/tracking/domain/usecases/track_user.dart';
import '../../features/tracking/presentation/notifiers/location_notifier.dart';
import '../adapters/firebase_auth_adapter.dart';
import '../adapters/firebase_storage_adapter.dart';
import '../adapters/firestore_adapter.dart';
import '../navigation/app_navigator.dart';
import '../platform/camera.dart';
import '../platform/location.dart';
import '../platform/network_info.dart';
import '../style/theme.dart';
import '../util/image.dart';
import '../util/localized_string.dart';
import '../util/notifications.dart';
import '../util/uuid_generator.dart';
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
    GetIt.I.registerLazySingleton<UUIDGenerator>(() => UUIDGenerator(Uuid()));
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
        GetIt.I<LocalizedStringImpl>(),
        LocationSource(),
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

    GetIt.I.registerLazySingleton<FirebaseStorageAdapterImpl>(
      () => FirebaseStorageAdapterImpl(FirebaseStorage.instance),
    );
  }

  // * DATA LAYER SINGLETON'S //

  static void registerDatasources() {
    // * Register all features datasource's

    GetIt.I.registerLazySingleton<AuthRemoteDataSourceImpl>(
      () => AuthRemoteDataSourceImpl(
        GetIt.I<FirestoreAdapterImpl>(),
        GetIt.I<FirebaseAuthAdapterImpl>(),
        GetIt.I<LocalizedStringImpl>(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationDataSourceImpl>(
      () => LocationDataSourceImpl(
        firestoreAdapter: GetIt.I(),
        locationUtils: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<OrganizationDataSourceImpl>(
      () => OrganizationDataSourceImpl(
        firebaseStorageAdapter: GetIt.I(),
        firestoreAdapter: GetIt.I(),
        localizedString: GetIt.I(),
        uuidGenerator: GetIt.I(),
      ),
    );
  }

  static void registerRepositories() {
    GetIt.I.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authDataSource: GetIt.I<AuthRemoteDataSourceImpl>(),
        userDataSource: GetIt.I<UserDataSourceImpl>(),
        networkInfo: GetIt.I<NetworkInfoImpl>(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
        dataSource: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<OrganizationRepository>(
      () => OrganizationRepositoryImpl(
        dataSource: GetIt.I<OrganizationDataSourceImpl>(),
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

    GetIt.I.registerLazySingleton<TrackUser>(
      () => TrackUser(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<CreateOrganization>(
      () => CreateOrganization(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetOrganization>(
      () => GetOrganization(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UpdateOrganization>(
      () => UpdateOrganization(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<DeleteOrganization>(
      () => DeleteOrganization(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UpdateMember>(
      () => UpdateMember(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<RemoveMember>(
      () => RemoveMember(
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

    GetIt.I.registerFactory<LocationNotifierImpl>(
      () => LocationNotifierImpl(
        GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<OrganizationNotifier>(
      () => OrganizationNotifierImpl(
        createOrganizationUseCase: GetIt.I(),
        deleteOrganizationUseCase: GetIt.I(),
        getOrganizationUseCase: GetIt.I(),
        removeMemberUseCase: GetIt.I(),
        updateMemberUseCase: GetIt.I(),
        updateOrganizationUseCase: GetIt.I(),
      ),
    );
  }
}
