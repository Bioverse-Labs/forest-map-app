import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:forest_map/core/adapters/firestore_adapter_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firestore_adapter_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot,
  MockSpec<QueryDocumentSnapshot>,
])
void main() {
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late FirestoreAdapterImpl firestoreAdapterImpl;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    firestoreAdapterImpl = FirestoreAdapterImpl(mockFirebaseFirestore);
  });

  group('Firestore Adapter', () {
    final tDocumentPath = '${faker.internet.domainName()}/${faker.guid.guid()}';
    final tDocumentPayload = {
      'id': faker.guid.guid(),
      'name': faker.person.name(),
      'email': faker.internet.email(),
    };

    setUp(() {
      when(mockFirebaseFirestore.doc(any)).thenReturn(mockDocumentReference);
      when(mockDocumentReference.get())
          .thenAnswer((_) async => mockDocumentSnapshot);
    });

    group('getDocument', () {
      test(
        'should get document from given path and return an DocumentSnapshot',
        () async {
          final result = await firestoreAdapterImpl.getDocument(tDocumentPath);

          verify(mockFirebaseFirestore.doc(tDocumentPath));
          verify(mockDocumentReference.get()).called(1);
          expect(result, mockDocumentSnapshot);
          verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
        },
      );
    });

    group('addDocument', () {
      test(
        'should insert new document in path and return an DocumentReference',
        () async {
          when(mockDocumentReference.set(any)).thenAnswer((_) async => null);
          when(mockDocumentSnapshot.exists).thenAnswer((_) => false);

          final result = await firestoreAdapterImpl.addDocument(
            tDocumentPath,
            tDocumentPayload,
          );

          verify(mockFirebaseFirestore.doc(tDocumentPath));
          verify(mockDocumentReference.set(tDocumentPayload));
          expect(result, mockDocumentReference);
        },
      );
    });

    group('updateDocument', () {
      test(
        'should update document data and return an DocumentReference',
        () async {
          final result = await firestoreAdapterImpl.updateDocument(
            tDocumentPath,
            tDocumentPayload,
          );

          verify(mockFirebaseFirestore.doc(tDocumentPath));
          verify(mockDocumentReference.update(tDocumentPayload));
          expect(result, mockDocumentReference);
          verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
        },
      );
    });

    group('deleteDocument', () {
      test(
        'should delete document from collection',
        () async {
          await firestoreAdapterImpl.deleteDocument(tDocumentPath);

          verify(mockFirebaseFirestore.doc(tDocumentPath));
          verify(mockDocumentReference.delete()).called(1);
          verifyNoMoreInteractions(mockFirebaseFirestore.doc(tDocumentPath));
        },
      );
    });

    group('runQuery', () {
      late MockQuery mockQuery;
      late MockQuerySnapshot mockQuerySnapshot;

      setUp(() {
        mockQuery = MockQuery();
        mockQuerySnapshot = MockQuerySnapshot();
      });

      test(
        ''' should get all documents from collection that matches query and
         return an List of QueryDocumentSnapshot
        ''',
        () async {
          when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
          when(mockQuerySnapshot.docs).thenReturn([]);

          await firestoreAdapterImpl.runQuery(mockQuery);

          verify(mockQuery.get());
          verifyNoMoreInteractions(mockQuery);
        },
      );
    });
  });
}
