import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreAdapter {
  FirebaseFirestore get firestore;

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
