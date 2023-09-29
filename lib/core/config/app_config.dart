import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import '../../features/auth/domain/usecases/forgot_password.dart';
import '../../features/catalog/presentation/notifiers/catalog_notifier.dart';
import '../../features/map/domain/usecases/get_first_point.dart';
import '../../features/post/data/hive/pending_post.dart';
import '../../features/post/domain/usecases/get_posts.dart';
import '../../features/tracking/data/datasources/location_local_data_source.dart';
import '../../features/tracking/domain/usecases/get_locations.dart';
import '../../features/tracking/domain/usecases/save_location.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_social.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/map/data/datasources/map_local_datasource.dart';
import '../../features/map/data/datasources/map_remote_datasource.dart';
import '../../features/map/data/hive/geolocation_file.dart';
import '../../features/map/data/repositories/geolocation_repository_impl.dart';
import '../../features/map/domain/repositories/geolocation_repository.dart';
import '../../features/map/domain/usecases/download_geo_data.dart';
import '../../features/map/domain/usecases/get_boundary.dart';
import '../../features/map/domain/usecases/get_geolocation_data.dart';
import '../../features/map/domain/usecases/get_villages.dart';
import '../../features/map/presentation/notifiers/map_notifier.dart';
import '../../features/organization/data/datasources/organization_local_data_source.dart';
import '../../features/organization/data/datasources/organization_remote_data_source.dart';
import '../../features/organization/data/hive/member.dart';
import '../../features/organization/data/hive/organization.dart';
import '../../features/organization/data/repositories/organization_repository_impl.dart';
import '../../features/organization/domain/repositories/organization_repository.dart';
import '../../features/organization/domain/usecases/add_member.dart';
import '../../features/organization/domain/usecases/create_organization.dart';
import '../../features/organization/domain/usecases/delete_organization.dart';
import '../../features/organization/domain/usecases/get_organization.dart';
import '../../features/organization/domain/usecases/remove_member.dart';
import '../../features/organization/domain/usecases/save_organization_locally.dart';
import '../../features/organization/domain/usecases/update_member.dart';
import '../../features/organization/domain/usecases/update_organization.dart';
import '../../features/organization/presentation/notifiers/organization_invite_notifier.dart';
import '../../features/organization/presentation/notifiers/organizations_notifier.dart';
import '../../features/post/data/datasources/post_local_data_source.dart';
import '../../features/post/data/datasources/post_remote_data_source.dart';
import '../../features/post/data/hive/post.dart';
import '../../features/post/data/repositories/post_repository_impl.dart';
import '../../features/post/domain/repositories/post_repository.dart';
import '../../features/post/domain/usecases/save_post.dart';
import '../../features/post/domain/usecases/upload_cached_post.dart';
import '../../features/post/presentation/notifier/post_notifier.dart';
import '../../features/tracking/data/datasources/location_remote_data_source.dart';
import '../../features/tracking/data/hive/location.dart';
import '../../features/tracking/data/repositories/location_repository_impl.dart';
import '../../features/tracking/domain/repositories/location_repository.dart';
import '../../features/tracking/domain/usecases/get_current_location.dart';
import '../../features/tracking/domain/usecases/track_user.dart';
import '../../features/tracking/presentation/notifiers/location_notifier.dart';
import '../../features/user/data/datasource/user_local_data_source.dart';
import '../../features/user/data/datasource/user_remote_data_source.dart';
import '../../features/user/data/hive/user.dart';
import '../../features/user/data/repository/user_repository_impl.dart';
import '../../features/user/domain/repository/user_repository.dart';
import '../../features/user/domain/usecases/get_user.dart';
import '../../features/user/domain/usecases/update_user.dart';
import '../../features/user/presentation/notifiers/user_notifier.dart';
import '../adapters/database_adapter.dart';
import '../adapters/firebase_auth_adapter.dart';
import '../adapters/firebase_storage_adapter.dart';
import '../adapters/firestore_adapter.dart';
import '../adapters/hive_adapter.dart';
import '../adapters/http_adapter.dart';
import '../enums/organization_member_status.dart';
import '../enums/organization_role_types.dart';
import '../navigation/app_navigator.dart';
import '../notifiers/home_screen_notifier.dart';
import '../platform/camera.dart';
import '../platform/location.dart';
import '../platform/network_info.dart';
import '../style/theme.dart';
import '../util/dir.dart';
import '../util/geojson.dart';
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

    Hive.registerAdapter(OrganizationRoleTypeAdapter());
    Hive.registerAdapter(OrganizationMemberStatusAdapter());
    Hive.registerAdapter(MemberHiveAdapter());
    Hive.registerAdapter(OrganizationHiveAdapter());
    Hive.registerAdapter(UserHiveAdapter());
    Hive.registerAdapter(LocationHiveAdapter());
    Hive.registerAdapter(PostHiveAdapter());
    Hive.registerAdapter(PendingPostHiveAdapter());
    Hive.registerAdapter(GeolocationFileHiveAdapter());
  }

  static void registerUtils() {
    GetIt.I.registerLazySingleton<LocalizedString>(
      () => LocalizedStringImpl(),
    );
    GetIt.I.registerLazySingleton<ImageUtilsImpl>(() => ImageUtilsImpl());
    GetIt.I.registerLazySingleton<NotificationsUtils>(
      () => NotificationsUtils(),
    );
    GetIt.I.registerLazySingleton<ValidationUtils>(() => ValidationUtils());
    GetIt.I.registerLazySingleton<UUIDGenerator>(() => UUIDGenerator(Uuid()));
    GetIt.I.registerLazySingleton<DirUtils>(() => DirUtils());
    GetIt.I.registerLazySingleton<GeoJsonUtils>(() => GeoJsonUtils());
    GetIt.I.registerLazySingleton<GeoFlutterFire>(() => GeoFlutterFire());
  }

  static void registerPlatformServices() {
    GetIt.I.registerLazySingleton<Camera>(
      () => CameraImpl(
        ImagePicker(),
        GetIt.I<ImageUtilsImpl>(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationUtils>(
      () => LocationUtilsImpl(
        GetIt.I(),
        LocationSource(),
      ),
    );

    GetIt.I.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(
        DataConnectionChecker(),
        Connectivity(),
      ),
    );

    GetIt.I.registerLazySingleton<AppSettings>(
      () => AppSettings(),
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

    GetIt.I.registerLazySingleton<HiveAdapter<OrganizationHive>>(
      () => HiveAdapter<OrganizationHive>('organization', Hive),
    );

    GetIt.I.registerLazySingleton<HiveAdapter<UserHive>>(
      () => HiveAdapter<UserHive>('user', Hive),
    );

    GetIt.I.registerLazySingleton<HiveAdapter<PostHive>>(
      () => HiveAdapter<PostHive>('posts', Hive),
    );

    GetIt.I.registerLazySingleton<HiveAdapter<PendingPostHive>>(
      () => HiveAdapter<PendingPostHive>('pending_posts', Hive),
    );

    GetIt.I.registerLazySingleton<HiveAdapter<GeolocationFileHive>>(
      () => HiveAdapter<GeolocationFileHive>('geofile', Hive),
    );

    GetIt.I.registerLazySingleton<HiveAdapter<LocationHive>>(
      () => HiveAdapter<LocationHive>('tracking', Hive),
    );

    GetIt.I.registerLazySingleton<HttpAdapter>(
      () => HttpAdapterImpl(),
    );

    GetIt.I.registerLazySingleton<DatabaseAdapter>(
      () => DatabaseAdapterImpl(
        dirUtils: GetIt.I(),
      ),
    );
  }

  static Future<void> initHiveAdapters() async {
    try {
      await GetIt.I<HiveAdapter<OrganizationHive>>().init();
      await GetIt.I<HiveAdapter<UserHive>>().init();
      await GetIt.I<HiveAdapter<PostHive>>().init();
      await GetIt.I<HiveAdapter<PendingPostHive>>().init();
      await GetIt.I<HiveAdapter<GeolocationFileHive>>().init();
      await GetIt.I<HiveAdapter<LocationHive>>().init();
    } catch (error) {}
  }

  static Future<void> disposeHiveAdapters() async {
    await GetIt.I<HiveAdapter<OrganizationHive>>().close();
    await GetIt.I<HiveAdapter<UserHive>>().close();
    await GetIt.I<HiveAdapter<PostHive>>().close();
    await GetIt.I<HiveAdapter<GeolocationFileHive>>().close();
    await GetIt.I<HiveAdapter<LocationHive>>().close();
  }

  // * DATA LAYER SINGLETON'S //

  static void registerDatasources() {
    // * Register all features datasource's

    GetIt.I.registerLazySingleton<AuthRemoteDataSourceImpl>(
      () => AuthRemoteDataSourceImpl(
        firestoreAdapter: GetIt.I<FirestoreAdapterImpl>(),
        firebaseAuthAdapter: GetIt.I<FirebaseAuthAdapterImpl>(),
        localizedString: GetIt.I(),
        userHive: GetIt.I(),
        orgHive: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationRemoteDataSource>(
      () => LocationRemoteDataSourceImpl(
        firestoreAdapter: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationLocalDataSource>(
      () => LocationLocalDataSourceImpl(
        hiveAdapter: GetIt.I(),
        locationUtils: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<OrganizationRemoteDataSource>(
      () => OrganizationRemoteDataSourceImpl(
        firebaseStorageAdapter: GetIt.I(),
        firestoreAdapter: GetIt.I(),
        localizedString: GetIt.I(),
        uuidGenerator: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<OrganizationLocalDataSource>(
      () => OrganizationLocalDataSourceImpl(
        orgHive: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(
        firestoreAdapter: GetIt.I(),
        firebaseStorageAdapter: GetIt.I(),
        localizedString: GetIt.I(),
        organizationRemoteDataSource: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(
        userHive: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(
        firebaseStorageAdapter: GetIt.I<FirebaseStorageAdapterImpl>(),
        firestoreAdapter: GetIt.I<FirestoreAdapterImpl>(),
        localizedString: GetIt.I(),
        uuidGenerator: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(
        postHiveAdapter: GetIt.I(),
        pendingPostHiveAdapter: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<MapRemoteDatasource>(
      () => MapRemoteDatasourceImpl(
        httpAdapter: GetIt.I(),
        firebaseStorageAdapter: GetIt.I(),
        dirUtils: GetIt.I(),
        geoJsonUtils: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<MapLocalDataSource>(
      () => MapLocalDataSourceImpl(
        databaseAdapter: GetIt.I(),
        hiveAdapter: GetIt.I(),
      ),
    );
  }

  static void registerRepositories() {
    // * REGISTER REPOSITORES HERE

    GetIt.I.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authDataSource: GetIt.I<AuthRemoteDataSourceImpl>(),
        userRemoteDataSource: GetIt.I(),
        userLocalDataSource: GetIt.I(),
        organizationLocalDataSource: GetIt.I(),
        networkInfo: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(
        remoteDataSource: GetIt.I(),
        localDataSource: GetIt.I(),
        networkInfo: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<OrganizationRepository>(
      () => OrganizationRepositoryImpl(
        remoteDataSource: GetIt.I(),
        localDataSource: GetIt.I(),
        networkInfo: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: GetIt.I(),
        localDataSource: GetIt.I(),
        networkInfo: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(
        remoteDataSource: GetIt.I(),
        localDataSource: GetIt.I(),
        networkInfo: GetIt.I(),
        locationUtils: GetIt.I(),
        uuidGenerator: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GeolocationRepository>(
      () => GeolocationRepositoryImpl(
        mapLocalDataSource: GetIt.I(),
        mapRemoteDatasource: GetIt.I(),
        geoFlutterFire: GetIt.I(),
        networkInfo: GetIt.I(),
        geoJsonUtils: GetIt.I(),
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

    GetIt.I.registerLazySingleton<SignOut>(
      () => SignOut(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<TrackUser>(
      () => TrackUser(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetCurrentLocation>(
      () => GetCurrentLocation(
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

    GetIt.I.registerLazySingleton<SaveOrganizationLocally>(
      () => SaveOrganizationLocally(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<AddMember>(
      () => AddMember(
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

    GetIt.I.registerLazySingleton<GetUser>(
      () => GetUser(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UpdateUser>(
      () => UpdateUser(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<SavePost>(
      () => SavePost(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<UploadCachedPost>(
      () => UploadCachedPost(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetGeolocationData>(
      () => GetGeolocationData(
        repository: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetFirstPoint>(
      () => GetFirstPoint(
        repository: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<DownloadGeoData>(
      () => DownloadGeoData(
        repository: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetBoundary>(
      () => GetBoundary(
        repository: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetVillages>(
      () => GetVillages(
        repository: GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetPosts>(
      () => GetPosts(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<SaveLocation>(
      () => SaveLocation(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<GetLocations>(
      () => GetLocations(
        GetIt.I(),
      ),
    );

    GetIt.I.registerLazySingleton<ForgotPassword>(
      () => ForgotPassword(
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
        GetIt.I(),
        GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<LocationNotifierImpl>(
      () => LocationNotifierImpl(
        trackUserUseCase: GetIt.I(),
        getCurrentLocationUseCase: GetIt.I(),
        saveLocationUseCase: GetIt.I(),
        getLocationsUseCase: GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<OrganizationNotifierImpl>(
      () => OrganizationNotifierImpl(
        createOrganizationUseCase: GetIt.I(),
        deleteOrganizationUseCase: GetIt.I(),
        getOrganizationUseCase: GetIt.I(),
        removeMemberUseCase: GetIt.I(),
        updateMemberUseCase: GetIt.I(),
        updateOrganizationUseCase: GetIt.I(),
        saveOrganizationLocallyUseCase: GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<OrganizationInviteNotifierImpl>(
      () => OrganizationInviteNotifierImpl(
        getOrganizationUseCase: GetIt.I(),
        addMemberUseCase: GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<UserNotifierImpl>(
      () => UserNotifierImpl(
        getUserUseCase: GetIt.I(),
        updateUserUseCase: GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<HomeScreenNotifierImpl>(
      () => HomeScreenNotifierImpl(),
    );

    GetIt.I.registerFactory<PostNotifierImpl>(
      () => PostNotifierImpl(
        getPostsUseCase: GetIt.I(),
        savePostUseCase: GetIt.I(),
        uploadCachedPostUseCase: GetIt.I(),
        postHive: GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<MapNotifierImpl>(
      () => MapNotifierImpl(
        downloadGeoDataUseCase: GetIt.I(),
        getGeolocationDataUseCase: GetIt.I(),
        getBoundaryUseCase: GetIt.I(),
        getVillagesUseCase: GetIt.I(),
        getFirstPointUseCase: GetIt.I(),
      ),
    );

    GetIt.I.registerFactory<CatalogNotifierImpl>(() => CatalogNotifierImpl());
  }
}
