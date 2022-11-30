// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:faker/faker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:forest_map_app/core/adapters/firebase_auth_adapter.dart';
// import 'package:forest_map_app/core/adapters/firestore_adapter.dart';
// import 'package:forest_map_app/core/adapters/hive_adapter.dart';
// import 'package:forest_map_app/core/enums/social_login_types.dart';
// import 'package:forest_map_app/core/errors/exceptions.dart';
// import 'package:forest_map_app/core/util/localized_string.dart';
// import 'package:forest_map_app/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:forest_map_app/features/organization/data/hive/organization.dart';
// import 'package:forest_map_app/features/user/data/hive/user.dart';
// import 'package:forest_map_app/features/user/data/models/user_model.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';

// class MockFirestoreAdapterImpl extends Mock implements FirestoreAdapterImpl {}

// class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

// class MockLocalizatedString extends Mock implements LocalizedString {}

// class MockSocialCredentialAdapterImpl extends Mock
//     implements SocialCredentialAdapterImpl {}

// class MockFirebaseAuthAdapterImpl extends Mock
//     implements FirebaseAuthAdapterImpl {}

// class MockAuthCredential extends Mock implements AuthCredential {}

// class MockDocumentReference extends Mock implements DocumentReference {}

// class MockUserHive extends Mock implements HiveAdapter<UserHive> {}

// class MockOrgHive extends Mock implements HiveAdapter<OrganizationHive> {}

// void main() {
//   MockFirestoreAdapterImpl mockFirestoreAdapterImpl;
//   MockFirebaseAuthAdapterImpl mockFirebaseAuthAdapterImpl;
//   MockDocumentSnapshot mockDocumentSnapshot;
//   MockLocalizatedString mockLocalizatedString;
//   MockUserHive mockUserHive;
//   MockOrgHive mockOrgHive;
//   AuthRemoteDataSourceImpl authRemoteDataSourceImpl;

//   setUp(() {
//     mockFirestoreAdapterImpl = MockFirestoreAdapterImpl();
//     mockFirebaseAuthAdapterImpl = MockFirebaseAuthAdapterImpl();
//     mockDocumentSnapshot = MockDocumentSnapshot();
//     mockLocalizatedString = MockLocalizatedString();
//     mockUserHive = MockUserHive();
//     mockOrgHive = MockOrgHive();
//     authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(
//       firestoreAdapter: mockFirestoreAdapterImpl,
//       firebaseAuthAdapter: mockFirebaseAuthAdapterImpl,
//       localizedString: mockLocalizatedString,
//       userHive: mockUserHive,
//       orgHive: mockOrgHive,
//     );
//   });

//   final tUserId = faker.guid.guid();
//   final tName = faker.person.name();
//   final tEmail = faker.internet.email();
//   final tAvatarUrl = faker.internet.uri('protocol');
//   final tPassword = faker.internet.password();
//   final tUserModel = UserModel(
//     id: tUserId,
//     name: tName,
//     email: tEmail,
//     avatarUrl: tAvatarUrl,
//   );
//   final tUserData = {
//     'id': tUserId,
//     'name': tName,
//     'email': tEmail,
//     'organizations': [],
//     'avatarUrl': tAvatarUrl,
//   };
//   final tExceptionMessage = faker.randomGenerator.string(20);

//   group('signInWithEmailAndPassword', () {
//     setUp(() {
//       when(mockDocumentSnapshot.data()).thenReturn(tUserData);
//       when(mockLocalizatedString.getLocalizedString(any))
//           .thenAnswer((_) => tExceptionMessage);
//     });

//     test(
//       ''' should return UserModal when signIn is succeed and document
//       from firestore is successfuly retrieved
//       ''',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithEmailAndPassword(any, any))
//             .thenAnswer((_) async => tUserModel);

//         final result = await authRemoteDataSourceImpl
//             .signInWithEmailAndPassword(tEmail, tPassword);

//         expect(result, tUserModel);
//         verify(mockFirebaseAuthAdapterImpl.signInWithEmailAndPassword(
//           tEmail,
//           tPassword,
//         ));
//         expect(result, tUserModel);
//         verifyNoMoreInteractions(mockFirebaseAuthAdapterImpl);
//       },
//     );

//     test(
//       'should throw ServerException if firebaseAuth fails to signIn',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithEmailAndPassword(any, any))
//             .thenThrow(FirebaseAuthException(
//           message: tExceptionMessage,
//           code: tExceptionMessage,
//         ));

//         final call = authRemoteDataSourceImpl.signInWithEmailAndPassword;

//         expect(
//           () => call(tEmail, tPassword),
//           throwsA(
//             isInstanceOf<ServerException>(),
//           ),
//         );
//       },
//     );
//   });

//   group('signInWithSocial', () {
//     MockAuthCredential mockAuthCredential;
//     MockDocumentReference mockDocumentReference;

//     setUp(() {
//       mockAuthCredential = MockAuthCredential();
//       mockDocumentReference = MockDocumentReference();
//       when(mockDocumentSnapshot.data()).thenReturn(tUserData);
//       when(mockLocalizatedString.getLocalizedString(any))
//           .thenAnswer((_) => tExceptionMessage);
//       when(mockFirebaseAuthAdapterImpl.getFacebookAuthCredential())
//           .thenAnswer((_) async => mockAuthCredential);
//       when(mockFirebaseAuthAdapterImpl.getGoogleAuthCredential())
//           .thenAnswer((_) async => mockAuthCredential);
//     });

//     test(
//       ''' should return UserModal when social signIn is succeed and document
//       from firestore is successfuly retrieved Facebook
//       ''',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithCredential(any))
//             .thenAnswer((_) async => tUserModel);
//         when(mockDocumentSnapshot.exists).thenReturn(true);
//         when(mockFirestoreAdapterImpl.getDocument(any))
//             .thenAnswer((_) async => mockDocumentSnapshot);

//         final result = await authRemoteDataSourceImpl
//             .signInWithSocial(SocialLoginType.facebook);

//         expect(result, tUserModel);
//         verify(mockFirebaseAuthAdapterImpl.signInWithCredential(
//           mockAuthCredential,
//         ));
//         verify(mockFirestoreAdapterImpl.getDocument('users/$tUserId'));
//         expect(result, tUserModel);
//         verifyNoMoreInteractions(mockFirestoreAdapterImpl);
//       },
//     );

//     test(
//       ''' should return UserModal when social signIn is succeed and document
//       from firestore is successfuly retrieved Google
//       ''',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithCredential(any))
//             .thenAnswer((_) async => tUserModel);
//         when(mockDocumentSnapshot.exists).thenReturn(true);
//         when(mockFirestoreAdapterImpl.getDocument(any))
//             .thenAnswer((_) async => mockDocumentSnapshot);

//         final result = await authRemoteDataSourceImpl
//             .signInWithSocial(SocialLoginType.google);

//         expect(result, tUserModel);
//         verify(mockFirebaseAuthAdapterImpl.signInWithCredential(
//           mockAuthCredential,
//         ));
//         verify(mockFirestoreAdapterImpl.getDocument('users/$tUserId'));
//         expect(result, tUserModel);
//         verifyNoMoreInteractions(mockFirestoreAdapterImpl);
//       },
//     );

//     test(
//       '''should create new document if document does not exist 
//       then return UserModel if frestore succeed
//       ''',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithCredential(any))
//             .thenAnswer((_) async => tUserModel);
//         when(mockFirestoreAdapterImpl.getDocument(any))
//             .thenAnswer((_) async => mockDocumentSnapshot);
//         when(mockDocumentSnapshot.exists).thenReturn(false);
//         when(mockFirestoreAdapterImpl.addDocument(any, any))
//             .thenAnswer((_) async => mockDocumentReference);

//         final result = await authRemoteDataSourceImpl
//             .signInWithSocial(SocialLoginType.facebook);

//         expect(result, tUserModel);
//       },
//     );

//     test(
//       'should throw ServerException if firebaseAuth fails to signIn',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithCredential(any))
//             .thenThrow(FirebaseAuthException(
//           message: tExceptionMessage,
//           code: tExceptionMessage,
//         ));

//         final call = authRemoteDataSourceImpl.signInWithSocial;

//         expect(
//           () => call(SocialLoginType.facebook),
//           throwsA(
//             isInstanceOf<ServerException>(),
//           ),
//         );
//       },
//     );

//     test(
//       'should throw ServerException if firestore fails',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signInWithCredential(any))
//             .thenAnswer((_) async => tUserModel);
//         when(mockFirestoreAdapterImpl.getDocument(any)).thenThrow(
//             FirebaseException(plugin: 'firestore', message: tExceptionMessage));

//         final call = authRemoteDataSourceImpl.signInWithSocial;

//         expect(
//           () => call(SocialLoginType.facebook),
//           throwsA(
//             isInstanceOf<ServerException>(),
//           ),
//         );
//       },
//     );
//   });

//   group('signUp', () {
//     final mockDocumentReference = MockDocumentReference();

//     test(
//       ''' should return UserModal when successfuly create a account in 
//       Firebase Auth and an Document in Firestore
//       ''',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signUpUserWithEmailAndPassword(
//           any,
//           any,
//         )).thenAnswer((_) async => tUserModel);
//         when(mockFirestoreAdapterImpl.addDocument(any, any))
//             .thenAnswer((_) async => mockDocumentReference);

//         final result =
//             await authRemoteDataSourceImpl.signUp(tName, tEmail, tPassword);

//         verify(mockFirestoreAdapterImpl.addDocument(
//           'users/$tUserId',
//           tUserData,
//         ));
//         expect(result, tUserModel);
//         verifyNoMoreInteractions(mockFirestoreAdapterImpl);
//       },
//     );

//     test(
//       'should throw ServerException if firebaseAuth fails to signUp',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signUpUserWithEmailAndPassword(
//           any,
//           any,
//         )).thenThrow(FirebaseAuthException(
//           message: tExceptionMessage,
//           code: tExceptionMessage,
//         ));

//         final call = authRemoteDataSourceImpl.signUp;

//         expect(
//           () => call(tName, tEmail, tPassword),
//           throwsA(
//             isInstanceOf<ServerException>(),
//           ),
//         );
//       },
//     );

//     test(
//       'should throw ServerException if firestore fails',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signUpUserWithEmailAndPassword(
//           any,
//           any,
//         )).thenAnswer((_) async => tUserModel);
//         when(mockFirestoreAdapterImpl.addDocument(any, any)).thenThrow(
//             FirebaseException(plugin: 'firestore', message: tExceptionMessage));

//         final call = authRemoteDataSourceImpl.signUp;

//         expect(
//           () => call(tName, tEmail, tPassword),
//           throwsA(
//             isInstanceOf<ServerException>(),
//           ),
//         );
//       },
//     );
//   });

//   group('signOut', () {
//     test(
//       'should signOut',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signOut())
//             .thenAnswer((_) async => null);

//         await authRemoteDataSourceImpl.signOut();

//         verify(mockFirebaseAuthAdapterImpl.signOut());
//       },
//     );

//     test(
//       'should signOut',
//       () async {
//         when(mockFirebaseAuthAdapterImpl.signOut()).thenThrow(
//           FirebaseAuthException(
//             message: tExceptionMessage,
//             code: tExceptionMessage,
//           ),
//         );

//         final call = authRemoteDataSourceImpl.signOut;

//         expect(() => call(), throwsA(isInstanceOf<ServerException>()));
//         verify(mockFirebaseAuthAdapterImpl.signOut());
//       },
//     );
//   });
// }
