import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums/exception_origin_types.dart';
import '../errors/exceptions.dart';

abstract class FirestoreAdapter {
  Future<DocumentSnapshot> getDocument(String documentPath);
  Future<DocumentReference> addDocument(
    String documentPath,
    Map<String, dynamic> payload,
  );
  Future<DocumentReference> updateDocument(
    String documentPath,
    Map<String, dynamic> payload,
  );
  Future<void> deleteDocument(String documentPath);
  Future<List<QueryDocumentSnapshot>> runQuery(Query query);
}

class FirestoreAdapterImpl implements FirestoreAdapter {
  final FirebaseFirestore firestore;

  FirestoreAdapterImpl(this.firestore);

  @override
  Future<DocumentReference> addDocument(
    String documentPath,
    Map<String, dynamic> payload,
  ) async {
    final docRef = firestore.doc(documentPath);

    if ((await docRef.get()).exists) {
      throw ServerException(
        'Document already exists',
        '400',
        ExceptionOriginTypes.firebaseFirestore,
      );
    }

    await docRef.set(payload);
    return docRef;
  }

  @override
  Future<void> deleteDocument(String documentPath) =>
      firestore.doc(documentPath).delete();

  @override
  Future<DocumentSnapshot> getDocument(String documentPath) =>
      firestore.doc(documentPath).get();

  @override
  Future<List<QueryDocumentSnapshot>> runQuery(Query query) async =>
      (await query.get()).docs;

  @override
  Future<DocumentReference> updateDocument(
    String documentPath,
    Map<String, dynamic> payload,
  ) async {
    final docRef = firestore.doc(documentPath);
    await docRef.update(payload);
    return docRef;
  }
}
