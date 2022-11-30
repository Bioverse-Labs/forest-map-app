// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:faker/faker.dart';
// import 'package:forest_map_app/core/adapters/firestore_adapter.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';

// class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// class MockDocumentReference extends Mock
//     implements DocumentReference<Map<String, dynamic>> {}

// class MockDocumentSnapshot extends Mock
//     implements DocumentSnapshot<Map<String, dynamic>> {}

// class MockQuery extends Mock implements Query {}

// class MockQuerySnapshot extends Mock implements QuerySnapshot {}

// class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

// void main() {
//   MockFirebaseFirestore mockFirebaseFirestore;
//   MockDocumentReference mockDocumentReference;
//   MockDocumentSnapshot mockDocumentSnapshot;
//   FirestoreAdapterImpl firestoreAdapterImpl;

//   setUp(() {
//     mockFirebaseFirestore = MockFirebaseFirestore();
//     mockDocumentReference = MockDocumentReference();
//     mockDocumentSnapshot = MockDocumentSnapshot();
//     firestoreAdapterImpl = FirestoreAdapterImpl(mockFirebaseFirestore);
//   });

//   group('Firestore Adapter', () {
//     final tDocumentPath = '${faker.internet.domainName()}/${faker.guid.guid()}';
//     final tDocumentPayload = {
//       'id': faker.guid.guid(),
//       'name': faker.person.name(),
//       'email': faker.internet.email(),
//     };

//     setUp(() {
//       when(mockFirebaseFirestore.doc(any)).thenReturn(mockDocumentReference);
//       when(mockDocumentReference.get())
//           .thenAnswer((_) async => mockDocumentSnapshot);
//     });

//     group('getDocument', () {
//       test(
//         'should get document from given path and return an DocumentSnapshot',
//         () async {
//           final result = await firestoreAdapterImpl.getDocument(tDocumentPath);

//           verify(mockFirebaseFirestore.doc(tDocumentPath));
//           verify(mockDocumentReference.get()).called(1);
//           expect(result, mockDocumentSnapshot);
//           verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
//         },
//       );
//     });

//     group('addDocument', () {
//       test(
//         'should insert new document in path and return an DocumentReference',
//         () async {
//           when(mockDocumentReference.set(any)).thenAnswer((_) async => null);

//           final result = await firestoreAdapterImpl.addDocument(
//             tDocumentPath,
//             tDocumentPayload,
//           );

//           verify(mockFirebaseFirestore.doc(tDocumentPath));
//           verify(mockDocumentReference.set(tDocumentPayload));
//           expect(result, mockDocumentReference);
//           verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
//         },
//       );
//     });

//     group('updateDocument', () {
//       test(
//         'should update document data and return an DocumentReference',
//         () async {
//           when(mockDocumentReference.update(any)).thenAnswer((_) => null);

//           final result = await firestoreAdapterImpl.updateDocument(
//             tDocumentPath,
//             tDocumentPayload,
//           );

//           verify(mockFirebaseFirestore.doc(tDocumentPath));
//           verify(mockDocumentReference.update(tDocumentPayload));
//           expect(result, mockDocumentReference);
//           verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
//         },
//       );
//     });

//     group('deleteDocument', () {
//       test(
//         'should delete document from collection',
//         () async {
//           when(mockDocumentReference.delete()).thenAnswer((_) => null);

//           await firestoreAdapterImpl.deleteDocument(tDocumentPath);

//           verify(mockFirebaseFirestore.doc(tDocumentPath));
//           verify(mockDocumentReference.delete()).called(1);
//           verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
//         },
//       );
//     });

//     group('runQuery', () {
//       MockQuery mockQuery;
//       MockQuerySnapshot mockQuerySnapshot;
//       MockQueryDocumentSnapshot mockQueryDocumentSnapshot;

//       setUp(() {
//         mockQuery = MockQuery();
//         mockQuerySnapshot = MockQuerySnapshot();
//         mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
//       });

//       test(
//         ''' should get all documents from collection that matches query and
//          return an List of QueryDocumentSnapshot
//         ''',
//         () async {
//           when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
//           when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

//           final result = await firestoreAdapterImpl.runQuery(mockQuery);

//           verify(mockQuery.get());
//           expect(result, [mockQueryDocumentSnapshot]);
//           verifyNoMoreInteractions(mockQuery);
//         },
//       );
//     });
//   });
// }
