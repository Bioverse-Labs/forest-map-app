// Mocks generated by Mockito 5.4.3 from annotations
// in forest_map/test/features/organization/data/datasources/organization_remote_data_source_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:io' as _i9;
import 'dart:typed_data' as _i12;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:firebase_core/firebase_core.dart' as _i4;
import 'package:firebase_storage/firebase_storage.dart' as _i3;
import 'package:forest_map/core/adapters/firebase_storage_adapter.dart' as _i7;
import 'package:forest_map/core/adapters/firestore_adapter_impl.dart' as _i6;
import 'package:forest_map/core/util/localized_string.dart' as _i10;
import 'package:forest_map/core/util/uuid_generator.dart' as _i11;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseFirestore_0 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocumentReference_1<T extends Object?> extends _i1.SmartFake
    implements _i2.DocumentReference<T> {
  _FakeDocumentReference_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocumentSnapshot_2<T extends Object?> extends _i1.SmartFake
    implements _i2.DocumentSnapshot<T> {
  _FakeDocumentSnapshot_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUploadTask_3 extends _i1.SmartFake implements _i3.UploadTask {
  _FakeUploadTask_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCollectionReference_4<T1 extends Object?> extends _i1.SmartFake
    implements _i2.CollectionReference<T1> {
  _FakeCollectionReference_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSnapshotMetadata_5 extends _i1.SmartFake
    implements _i2.SnapshotMetadata {
  _FakeSnapshotMetadata_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuery_6<T1 extends Object?> extends _i1.SmartFake
    implements _i2.Query<T1> {
  _FakeQuery_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuerySnapshot_7<T1 extends Object?> extends _i1.SmartFake
    implements _i2.QuerySnapshot<T1> {
  _FakeQuerySnapshot_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAggregateQuery_8 extends _i1.SmartFake
    implements _i2.AggregateQuery {
  _FakeAggregateQuery_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseApp_9 extends _i1.SmartFake implements _i4.FirebaseApp {
  _FakeFirebaseApp_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSettings_10 extends _i1.SmartFake implements _i2.Settings {
  _FakeSettings_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWriteBatch_11 extends _i1.SmartFake implements _i2.WriteBatch {
  _FakeWriteBatch_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLoadBundleTask_12 extends _i1.SmartFake
    implements _i2.LoadBundleTask {
  _FakeLoadBundleTask_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_13<T1> extends _i1.SmartFake implements _i5.Future<T1> {
  _FakeFuture_13(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FirestoreAdapterImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirestoreAdapterImpl extends _i1.Mock
    implements _i6.FirestoreAdapterImpl {
  MockFirestoreAdapterImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i5.Future<_i2.DocumentReference<Object?>> addDocument(
    String? documentPath,
    Map<String, dynamic>? payload,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addDocument,
          [
            documentPath,
            payload,
          ],
        ),
        returnValue: _i5.Future<_i2.DocumentReference<Object?>>.value(
            _FakeDocumentReference_1<Object?>(
          this,
          Invocation.method(
            #addDocument,
            [
              documentPath,
              payload,
            ],
          ),
        )),
      ) as _i5.Future<_i2.DocumentReference<Object?>>);

  @override
  _i5.Future<void> deleteDocument(String? documentPath) => (super.noSuchMethod(
        Invocation.method(
          #deleteDocument,
          [documentPath],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i2.DocumentSnapshot<Object?>> getDocument(String? documentPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDocument,
          [documentPath],
        ),
        returnValue: _i5.Future<_i2.DocumentSnapshot<Object?>>.value(
            _FakeDocumentSnapshot_2<Object?>(
          this,
          Invocation.method(
            #getDocument,
            [documentPath],
          ),
        )),
      ) as _i5.Future<_i2.DocumentSnapshot<Object?>>);

  @override
  _i5.Future<List<_i2.QueryDocumentSnapshot<Object?>>> runQuery(
          _i2.Query<Object?>? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #runQuery,
          [query],
        ),
        returnValue: _i5.Future<List<_i2.QueryDocumentSnapshot<Object?>>>.value(
            <_i2.QueryDocumentSnapshot<Object?>>[]),
      ) as _i5.Future<List<_i2.QueryDocumentSnapshot<Object?>>>);

  @override
  _i5.Future<_i2.DocumentReference<Object?>> updateDocument(
    String? documentPath,
    Map<String, dynamic>? payload,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateDocument,
          [
            documentPath,
            payload,
          ],
        ),
        returnValue: _i5.Future<_i2.DocumentReference<Object?>>.value(
            _FakeDocumentReference_1<Object?>(
          this,
          Invocation.method(
            #updateDocument,
            [
              documentPath,
              payload,
            ],
          ),
        )),
      ) as _i5.Future<_i2.DocumentReference<Object?>>);
}

/// A class which mocks [FirebaseStorageAdapterImpl].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseStorageAdapterImpl extends _i1.Mock
    implements _i7.FirebaseStorageAdapterImpl {
  MockFirebaseStorageAdapterImpl() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<String> getDownloadUrl(String? storagePath) => (super.noSuchMethod(
        Invocation.method(
          #getDownloadUrl,
          [storagePath],
        ),
        returnValue: _i5.Future<String>.value(_i8.dummyValue<String>(
          this,
          Invocation.method(
            #getDownloadUrl,
            [storagePath],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i3.UploadTask uploadFile({
    _i9.File? file,
    String? storagePath,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadFile,
          [],
          {
            #file: file,
            #storagePath: storagePath,
          },
        ),
        returnValue: _FakeUploadTask_3(
          this,
          Invocation.method(
            #uploadFile,
            [],
            {
              #file: file,
              #storagePath: storagePath,
            },
          ),
        ),
      ) as _i3.UploadTask);
}

/// A class which mocks [LocalizedString].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalizedString extends _i1.Mock implements _i10.LocalizedString {
  MockLocalizedString() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String getLocalizedString(
    String? identifier, {
    Map<String, String>? namedArgs,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLocalizedString,
          [identifier],
          {#namedArgs: namedArgs},
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #getLocalizedString,
            [identifier],
            {#namedArgs: namedArgs},
          ),
        ),
      ) as String);
}

/// A class which mocks [UUIDGenerator].
///
/// See the documentation for Mockito's code generation for more information.
class MockUUIDGenerator extends _i1.Mock implements _i11.UUIDGenerator {
  MockUUIDGenerator() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String generateUID() => (super.noSuchMethod(
        Invocation.method(
          #generateUID,
          [],
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #generateUID,
            [],
          ),
        ),
      ) as String);
}

/// A class which mocks [DocumentReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockDocumentReference<T extends Object?> extends _i1.Mock
    implements _i2.DocumentReference<T> {
  MockDocumentReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
      ) as String);

  @override
  _i2.CollectionReference<T> get parent => (super.noSuchMethod(
        Invocation.getter(#parent),
        returnValue: _FakeCollectionReference_4<T>(
          this,
          Invocation.getter(#parent),
        ),
      ) as _i2.CollectionReference<T>);

  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#path),
        ),
      ) as String);

  @override
  _i2.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #collection,
          [collectionPath],
        ),
        returnValue: _FakeCollectionReference_4<Map<String, dynamic>>(
          this,
          Invocation.method(
            #collection,
            [collectionPath],
          ),
        ),
      ) as _i2.CollectionReference<Map<String, dynamic>>);

  @override
  _i5.Future<void> delete() => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> update(Map<Object, Object?>? data) => (super.noSuchMethod(
        Invocation.method(
          #update,
          [data],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i2.DocumentSnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [options],
        ),
        returnValue: _i5.Future<_i2.DocumentSnapshot<T>>.value(
            _FakeDocumentSnapshot_2<T>(
          this,
          Invocation.method(
            #get,
            [options],
          ),
        )),
      ) as _i5.Future<_i2.DocumentSnapshot<T>>);

  @override
  _i5.Stream<_i2.DocumentSnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #snapshots,
          [],
          {#includeMetadataChanges: includeMetadataChanges},
        ),
        returnValue: _i5.Stream<_i2.DocumentSnapshot<T>>.empty(),
      ) as _i5.Stream<_i2.DocumentSnapshot<T>>);

  @override
  _i5.Future<void> set(
    T? data, [
    _i2.SetOptions? options,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #set,
          [
            data,
            options,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.DocumentReference<R> withConverter<R>({
    required _i2.FromFirestore<R>? fromFirestore,
    required _i2.ToFirestore<R>? toFirestore,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #withConverter,
          [],
          {
            #fromFirestore: fromFirestore,
            #toFirestore: toFirestore,
          },
        ),
        returnValue: _FakeDocumentReference_1<R>(
          this,
          Invocation.method(
            #withConverter,
            [],
            {
              #fromFirestore: fromFirestore,
              #toFirestore: toFirestore,
            },
          ),
        ),
      ) as _i2.DocumentReference<R>);
}

/// A class which mocks [DocumentSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocumentSnapshot<T extends Object?> extends _i1.Mock
    implements _i2.DocumentSnapshot<T> {
  MockDocumentSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
      ) as String);

  @override
  _i2.DocumentReference<T> get reference => (super.noSuchMethod(
        Invocation.getter(#reference),
        returnValue: _FakeDocumentReference_1<T>(
          this,
          Invocation.getter(#reference),
        ),
      ) as _i2.DocumentReference<T>);

  @override
  _i2.SnapshotMetadata get metadata => (super.noSuchMethod(
        Invocation.getter(#metadata),
        returnValue: _FakeSnapshotMetadata_5(
          this,
          Invocation.getter(#metadata),
        ),
      ) as _i2.SnapshotMetadata);

  @override
  bool get exists => (super.noSuchMethod(
        Invocation.getter(#exists),
        returnValue: false,
      ) as bool);

  @override
  dynamic get(Object? field) => super.noSuchMethod(Invocation.method(
        #get,
        [field],
      ));

  @override
  dynamic operator [](Object? field) => super.noSuchMethod(Invocation.method(
        #[],
        [field],
      ));
}

/// A class which mocks [CollectionReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockCollectionReference<T extends Object?> extends _i1.Mock
    implements _i2.CollectionReference<T> {
  MockCollectionReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
      ) as String);

  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#path),
        ),
      ) as String);

  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  Map<String, dynamic> get parameters => (super.noSuchMethod(
        Invocation.getter(#parameters),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);

  @override
  _i5.Future<_i2.DocumentReference<T>> add(T? data) => (super.noSuchMethod(
        Invocation.method(
          #add,
          [data],
        ),
        returnValue: _i5.Future<_i2.DocumentReference<T>>.value(
            _FakeDocumentReference_1<T>(
          this,
          Invocation.method(
            #add,
            [data],
          ),
        )),
      ) as _i5.Future<_i2.DocumentReference<T>>);

  @override
  _i2.DocumentReference<T> doc([String? path]) => (super.noSuchMethod(
        Invocation.method(
          #doc,
          [path],
        ),
        returnValue: _FakeDocumentReference_1<T>(
          this,
          Invocation.method(
            #doc,
            [path],
          ),
        ),
      ) as _i2.DocumentReference<T>);

  @override
  _i2.CollectionReference<R> withConverter<R extends Object?>({
    required _i2.FromFirestore<R>? fromFirestore,
    required _i2.ToFirestore<R>? toFirestore,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #withConverter,
          [],
          {
            #fromFirestore: fromFirestore,
            #toFirestore: toFirestore,
          },
        ),
        returnValue: _FakeCollectionReference_4<R>(
          this,
          Invocation.method(
            #withConverter,
            [],
            {
              #fromFirestore: fromFirestore,
              #toFirestore: toFirestore,
            },
          ),
        ),
      ) as _i2.CollectionReference<R>);

  @override
  _i2.Query<T> endAtDocument(_i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
        Invocation.method(
          #endAtDocument,
          [documentSnapshot],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #endAtDocument,
            [documentSnapshot],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> endAt(Iterable<Object?>? values) => (super.noSuchMethod(
        Invocation.method(
          #endAt,
          [values],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #endAt,
            [values],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> endBeforeDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
        Invocation.method(
          #endBeforeDocument,
          [documentSnapshot],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #endBeforeDocument,
            [documentSnapshot],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> endBefore(Iterable<Object?>? values) => (super.noSuchMethod(
        Invocation.method(
          #endBefore,
          [values],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #endBefore,
            [values],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i5.Future<_i2.QuerySnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [options],
        ),
        returnValue:
            _i5.Future<_i2.QuerySnapshot<T>>.value(_FakeQuerySnapshot_7<T>(
          this,
          Invocation.method(
            #get,
            [options],
          ),
        )),
      ) as _i5.Future<_i2.QuerySnapshot<T>>);

  @override
  _i2.Query<T> limit(int? limit) => (super.noSuchMethod(
        Invocation.method(
          #limit,
          [limit],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #limit,
            [limit],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> limitToLast(int? limit) => (super.noSuchMethod(
        Invocation.method(
          #limitToLast,
          [limit],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #limitToLast,
            [limit],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i5.Stream<_i2.QuerySnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #snapshots,
          [],
          {#includeMetadataChanges: includeMetadataChanges},
        ),
        returnValue: _i5.Stream<_i2.QuerySnapshot<T>>.empty(),
      ) as _i5.Stream<_i2.QuerySnapshot<T>>);

  @override
  _i2.Query<T> orderBy(
    Object? field, {
    bool? descending = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #orderBy,
          [field],
          {#descending: descending},
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #orderBy,
            [field],
            {#descending: descending},
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> startAfterDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
        Invocation.method(
          #startAfterDocument,
          [documentSnapshot],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #startAfterDocument,
            [documentSnapshot],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> startAfter(Iterable<Object?>? values) => (super.noSuchMethod(
        Invocation.method(
          #startAfter,
          [values],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #startAfter,
            [values],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> startAtDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
        Invocation.method(
          #startAtDocument,
          [documentSnapshot],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #startAtDocument,
            [documentSnapshot],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> startAt(Iterable<Object?>? values) => (super.noSuchMethod(
        Invocation.method(
          #startAt,
          [values],
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #startAt,
            [values],
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.Query<T> where(
    Object? field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #where,
          [field],
          {
            #isEqualTo: isEqualTo,
            #isNotEqualTo: isNotEqualTo,
            #isLessThan: isLessThan,
            #isLessThanOrEqualTo: isLessThanOrEqualTo,
            #isGreaterThan: isGreaterThan,
            #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            #arrayContains: arrayContains,
            #arrayContainsAny: arrayContainsAny,
            #whereIn: whereIn,
            #whereNotIn: whereNotIn,
            #isNull: isNull,
          },
        ),
        returnValue: _FakeQuery_6<T>(
          this,
          Invocation.method(
            #where,
            [field],
            {
              #isEqualTo: isEqualTo,
              #isNotEqualTo: isNotEqualTo,
              #isLessThan: isLessThan,
              #isLessThanOrEqualTo: isLessThanOrEqualTo,
              #isGreaterThan: isGreaterThan,
              #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              #arrayContains: arrayContains,
              #arrayContainsAny: arrayContainsAny,
              #whereIn: whereIn,
              #whereNotIn: whereNotIn,
              #isNull: isNull,
            },
          ),
        ),
      ) as _i2.Query<T>);

  @override
  _i2.AggregateQuery count() => (super.noSuchMethod(
        Invocation.method(
          #count,
          [],
        ),
        returnValue: _FakeAggregateQuery_8(
          this,
          Invocation.method(
            #count,
            [],
          ),
        ),
      ) as _i2.AggregateQuery);
}

/// A class which mocks [FirebaseFirestore].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseFirestore extends _i1.Mock implements _i2.FirebaseFirestore {
  MockFirebaseFirestore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseApp get app => (super.noSuchMethod(
        Invocation.getter(#app),
        returnValue: _FakeFirebaseApp_9(
          this,
          Invocation.getter(#app),
        ),
      ) as _i4.FirebaseApp);

  @override
  set app(_i4.FirebaseApp? _app) => super.noSuchMethod(
        Invocation.setter(
          #app,
          _app,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get databaseURL => (super.noSuchMethod(
        Invocation.getter(#databaseURL),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#databaseURL),
        ),
      ) as String);

  @override
  set databaseURL(String? _databaseURL) => super.noSuchMethod(
        Invocation.setter(
          #databaseURL,
          _databaseURL,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set settings(_i2.Settings? settings) => super.noSuchMethod(
        Invocation.setter(
          #settings,
          settings,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Settings get settings => (super.noSuchMethod(
        Invocation.getter(#settings),
        returnValue: _FakeSettings_10(
          this,
          Invocation.getter(#settings),
        ),
      ) as _i2.Settings);

  @override
  Map<dynamic, dynamic> get pluginConstants => (super.noSuchMethod(
        Invocation.getter(#pluginConstants),
        returnValue: <dynamic, dynamic>{},
      ) as Map<dynamic, dynamic>);

  @override
  _i2.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #collection,
          [collectionPath],
        ),
        returnValue: _FakeCollectionReference_4<Map<String, dynamic>>(
          this,
          Invocation.method(
            #collection,
            [collectionPath],
          ),
        ),
      ) as _i2.CollectionReference<Map<String, dynamic>>);

  @override
  _i2.WriteBatch batch() => (super.noSuchMethod(
        Invocation.method(
          #batch,
          [],
        ),
        returnValue: _FakeWriteBatch_11(
          this,
          Invocation.method(
            #batch,
            [],
          ),
        ),
      ) as _i2.WriteBatch);

  @override
  _i5.Future<void> clearPersistence() => (super.noSuchMethod(
        Invocation.method(
          #clearPersistence,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> enablePersistence(
          [_i2.PersistenceSettings? persistenceSettings]) =>
      (super.noSuchMethod(
        Invocation.method(
          #enablePersistence,
          [persistenceSettings],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.LoadBundleTask loadBundle(_i12.Uint8List? bundle) => (super.noSuchMethod(
        Invocation.method(
          #loadBundle,
          [bundle],
        ),
        returnValue: _FakeLoadBundleTask_12(
          this,
          Invocation.method(
            #loadBundle,
            [bundle],
          ),
        ),
      ) as _i2.LoadBundleTask);

  @override
  void useFirestoreEmulator(
    String? host,
    int? port, {
    bool? sslEnabled = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #useFirestoreEmulator,
          [
            host,
            port,
          ],
          {#sslEnabled: sslEnabled},
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<_i2.QuerySnapshot<T>> namedQueryWithConverterGet<T>(
    String? name, {
    _i2.GetOptions? options = const _i2.GetOptions(),
    required _i2.FromFirestore<T>? fromFirestore,
    required _i2.ToFirestore<T>? toFirestore,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #namedQueryWithConverterGet,
          [name],
          {
            #options: options,
            #fromFirestore: fromFirestore,
            #toFirestore: toFirestore,
          },
        ),
        returnValue:
            _i5.Future<_i2.QuerySnapshot<T>>.value(_FakeQuerySnapshot_7<T>(
          this,
          Invocation.method(
            #namedQueryWithConverterGet,
            [name],
            {
              #options: options,
              #fromFirestore: fromFirestore,
              #toFirestore: toFirestore,
            },
          ),
        )),
      ) as _i5.Future<_i2.QuerySnapshot<T>>);

  @override
  _i5.Future<_i2.QuerySnapshot<Map<String, dynamic>>> namedQueryGet(
    String? name, {
    _i2.GetOptions? options = const _i2.GetOptions(),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #namedQueryGet,
          [name],
          {#options: options},
        ),
        returnValue: _i5.Future<_i2.QuerySnapshot<Map<String, dynamic>>>.value(
            _FakeQuerySnapshot_7<Map<String, dynamic>>(
          this,
          Invocation.method(
            #namedQueryGet,
            [name],
            {#options: options},
          ),
        )),
      ) as _i5.Future<_i2.QuerySnapshot<Map<String, dynamic>>>);

  @override
  _i2.Query<Map<String, dynamic>> collectionGroup(String? collectionPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #collectionGroup,
          [collectionPath],
        ),
        returnValue: _FakeQuery_6<Map<String, dynamic>>(
          this,
          Invocation.method(
            #collectionGroup,
            [collectionPath],
          ),
        ),
      ) as _i2.Query<Map<String, dynamic>>);

  @override
  _i5.Future<void> disableNetwork() => (super.noSuchMethod(
        Invocation.method(
          #disableNetwork,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.DocumentReference<Map<String, dynamic>> doc(String? documentPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #doc,
          [documentPath],
        ),
        returnValue: _FakeDocumentReference_1<Map<String, dynamic>>(
          this,
          Invocation.method(
            #doc,
            [documentPath],
          ),
        ),
      ) as _i2.DocumentReference<Map<String, dynamic>>);

  @override
  _i5.Future<void> enableNetwork() => (super.noSuchMethod(
        Invocation.method(
          #enableNetwork,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Stream<void> snapshotsInSync() => (super.noSuchMethod(
        Invocation.method(
          #snapshotsInSync,
          [],
        ),
        returnValue: _i5.Stream<void>.empty(),
      ) as _i5.Stream<void>);

  @override
  _i5.Future<T> runTransaction<T>(
    _i2.TransactionHandler<T>? transactionHandler, {
    Duration? timeout = const Duration(seconds: 30),
    int? maxAttempts = 5,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #runTransaction,
          [transactionHandler],
          {
            #timeout: timeout,
            #maxAttempts: maxAttempts,
          },
        ),
        returnValue: _i8.ifNotNull(
              _i8.dummyValueOrNull<T>(
                this,
                Invocation.method(
                  #runTransaction,
                  [transactionHandler],
                  {
                    #timeout: timeout,
                    #maxAttempts: maxAttempts,
                  },
                ),
              ),
              (T v) => _i5.Future<T>.value(v),
            ) ??
            _FakeFuture_13<T>(
              this,
              Invocation.method(
                #runTransaction,
                [transactionHandler],
                {
                  #timeout: timeout,
                  #maxAttempts: maxAttempts,
                },
              ),
            ),
      ) as _i5.Future<T>);

  @override
  _i5.Future<void> terminate() => (super.noSuchMethod(
        Invocation.method(
          #terminate,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> waitForPendingWrites() => (super.noSuchMethod(
        Invocation.method(
          #waitForPendingWrites,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setIndexConfiguration({
    required List<_i2.Index>? indexes,
    List<_i2.FieldOverrides>? fieldOverrides,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setIndexConfiguration,
          [],
          {
            #indexes: indexes,
            #fieldOverrides: fieldOverrides,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setIndexConfigurationFromJSON(String? json) =>
      (super.noSuchMethod(
        Invocation.method(
          #setIndexConfigurationFromJSON,
          [json],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [QueryDocumentSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockQueryDocumentSnapshot extends _i1.Mock
    implements _i2.QueryDocumentSnapshot<Map<String, dynamic>> {
  MockQueryDocumentSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.getter(#id),
        ),
      ) as String);

  @override
  _i2.DocumentReference<Map<String, dynamic>> get reference =>
      (super.noSuchMethod(
        Invocation.getter(#reference),
        returnValue: _FakeDocumentReference_1<Map<String, dynamic>>(
          this,
          Invocation.getter(#reference),
        ),
      ) as _i2.DocumentReference<Map<String, dynamic>>);

  @override
  _i2.SnapshotMetadata get metadata => (super.noSuchMethod(
        Invocation.getter(#metadata),
        returnValue: _FakeSnapshotMetadata_5(
          this,
          Invocation.getter(#metadata),
        ),
      ) as _i2.SnapshotMetadata);

  @override
  bool get exists => (super.noSuchMethod(
        Invocation.getter(#exists),
        returnValue: false,
      ) as bool);

  @override
  Map<String, dynamic> data() => (super.noSuchMethod(
        Invocation.method(
          #data,
          [],
        ),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);

  @override
  dynamic get(Object? field) => super.noSuchMethod(Invocation.method(
        #get,
        [field],
      ));

  @override
  dynamic operator [](Object? field) => super.noSuchMethod(Invocation.method(
        #[],
        [field],
      ));
}
