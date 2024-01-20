// Mocks generated by Mockito 5.4.0 from annotations
// in forest_map/test/core/adapters/firestore_adapter_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:typed_data' as _i6;

import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart'
    as _i3;
import 'package:firebase_core/firebase_core.dart' as _i2;
import 'package:mockito/annotations.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseApp_0 extends _i1.SmartFake implements _i2.FirebaseApp {
  _FakeFirebaseApp_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSettings_1 extends _i1.SmartFake implements _i3.Settings {
  _FakeSettings_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCollectionReference_2<T extends Object?> extends _i1.SmartFake
    implements _i4.CollectionReference<T> {
  _FakeCollectionReference_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWriteBatch_3 extends _i1.SmartFake implements _i4.WriteBatch {
  _FakeWriteBatch_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLoadBundleTask_4 extends _i1.SmartFake
    implements _i4.LoadBundleTask {
  _FakeLoadBundleTask_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuerySnapshot_5<T extends Object?> extends _i1.SmartFake
    implements _i4.QuerySnapshot<T> {
  _FakeQuerySnapshot_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQuery_6<T extends Object?> extends _i1.SmartFake
    implements _i4.Query<T> {
  _FakeQuery_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocumentReference_7<T extends Object?> extends _i1.SmartFake
    implements _i4.DocumentReference<T> {
  _FakeDocumentReference_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFuture_8<T> extends _i1.SmartFake implements _i5.Future<T> {
  _FakeFuture_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseFirestore_9 extends _i1.SmartFake
    implements _i4.FirebaseFirestore {
  _FakeFirebaseFirestore_9(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDocumentSnapshot_10<T extends Object?> extends _i1.SmartFake
    implements _i4.DocumentSnapshot<T> {
  _FakeDocumentSnapshot_10(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSnapshotMetadata_11 extends _i1.SmartFake
    implements _i4.SnapshotMetadata {
  _FakeSnapshotMetadata_11(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAggregateQuery_12 extends _i1.SmartFake
    implements _i4.AggregateQuery {
  _FakeAggregateQuery_12(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FirebaseFirestore].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseFirestore extends _i1.Mock implements _i4.FirebaseFirestore {
  MockFirebaseFirestore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(
        Invocation.getter(#app),
        returnValue: _FakeFirebaseApp_0(
          this,
          Invocation.getter(#app),
        ),
      ) as _i2.FirebaseApp);
  @override
  set app(_i2.FirebaseApp? _app) => super.noSuchMethod(
        Invocation.setter(
          #app,
          _app,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get databaseURL => (super.noSuchMethod(
        Invocation.getter(#databaseURL),
        returnValue: '',
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
  set settings(_i3.Settings? settings) => super.noSuchMethod(
        Invocation.setter(
          #settings,
          settings,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.Settings get settings => (super.noSuchMethod(
        Invocation.getter(#settings),
        returnValue: _FakeSettings_1(
          this,
          Invocation.getter(#settings),
        ),
      ) as _i3.Settings);
  @override
  Map<dynamic, dynamic> get pluginConstants => (super.noSuchMethod(
        Invocation.getter(#pluginConstants),
        returnValue: <dynamic, dynamic>{},
      ) as Map<dynamic, dynamic>);
  @override
  _i4.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #collection,
          [collectionPath],
        ),
        returnValue: _FakeCollectionReference_2<Map<String, dynamic>>(
          this,
          Invocation.method(
            #collection,
            [collectionPath],
          ),
        ),
      ) as _i4.CollectionReference<Map<String, dynamic>>);
  @override
  _i4.WriteBatch batch() => (super.noSuchMethod(
        Invocation.method(
          #batch,
          [],
        ),
        returnValue: _FakeWriteBatch_3(
          this,
          Invocation.method(
            #batch,
            [],
          ),
        ),
      ) as _i4.WriteBatch);
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
          [_i3.PersistenceSettings? persistenceSettings]) =>
      (super.noSuchMethod(
        Invocation.method(
          #enablePersistence,
          [persistenceSettings],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
  @override
  _i4.LoadBundleTask loadBundle(_i6.Uint8List? bundle) => (super.noSuchMethod(
        Invocation.method(
          #loadBundle,
          [bundle],
        ),
        returnValue: _FakeLoadBundleTask_4(
          this,
          Invocation.method(
            #loadBundle,
            [bundle],
          ),
        ),
      ) as _i4.LoadBundleTask);
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
  _i5.Future<_i4.QuerySnapshot<T>> namedQueryWithConverterGet<T>(
    String? name, {
    _i3.GetOptions? options = const _i3.GetOptions(),
    required _i4.FromFirestore<T>? fromFirestore,
    required _i4.ToFirestore<T>? toFirestore,
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
            _i5.Future<_i4.QuerySnapshot<T>>.value(_FakeQuerySnapshot_5<T>(
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
      ) as _i5.Future<_i4.QuerySnapshot<T>>);
  @override
  _i5.Future<_i4.QuerySnapshot<Map<String, dynamic>>> namedQueryGet(
    String? name, {
    _i3.GetOptions? options = const _i3.GetOptions(),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #namedQueryGet,
          [name],
          {#options: options},
        ),
        returnValue: _i5.Future<_i4.QuerySnapshot<Map<String, dynamic>>>.value(
            _FakeQuerySnapshot_5<Map<String, dynamic>>(
          this,
          Invocation.method(
            #namedQueryGet,
            [name],
            {#options: options},
          ),
        )),
      ) as _i5.Future<_i4.QuerySnapshot<Map<String, dynamic>>>);
  @override
  _i4.Query<Map<String, dynamic>> collectionGroup(String? collectionPath) =>
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
      ) as _i4.Query<Map<String, dynamic>>);
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
  _i4.DocumentReference<Map<String, dynamic>> doc(String? documentPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #doc,
          [documentPath],
        ),
        returnValue: _FakeDocumentReference_7<Map<String, dynamic>>(
          this,
          Invocation.method(
            #doc,
            [documentPath],
          ),
        ),
      ) as _i4.DocumentReference<Map<String, dynamic>>);
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
    _i4.TransactionHandler<T>? transactionHandler, {
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
        returnValue: _FakeFuture_8<T>(
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
    required List<_i3.Index>? indexes,
    List<_i3.FieldOverrides>? fieldOverrides,
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

/// A class which mocks [DocumentReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockDocumentReference<T extends Object?> extends _i1.Mock
    implements _i4.DocumentReference<T> {
  MockDocumentReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_9(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i4.FirebaseFirestore);
  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: '',
      ) as String);
  @override
  _i4.CollectionReference<T> get parent => (super.noSuchMethod(
        Invocation.getter(#parent),
        returnValue: _FakeCollectionReference_2<T>(
          this,
          Invocation.getter(#parent),
        ),
      ) as _i4.CollectionReference<T>);
  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: '',
      ) as String);
  @override
  _i4.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(
        Invocation.method(
          #collection,
          [collectionPath],
        ),
        returnValue: _FakeCollectionReference_2<Map<String, dynamic>>(
          this,
          Invocation.method(
            #collection,
            [collectionPath],
          ),
        ),
      ) as _i4.CollectionReference<Map<String, dynamic>>);
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
  _i5.Future<_i4.DocumentSnapshot<T>> get([_i3.GetOptions? options]) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [options],
        ),
        returnValue: _i5.Future<_i4.DocumentSnapshot<T>>.value(
            _FakeDocumentSnapshot_10<T>(
          this,
          Invocation.method(
            #get,
            [options],
          ),
        )),
      ) as _i5.Future<_i4.DocumentSnapshot<T>>);
  @override
  _i5.Stream<_i4.DocumentSnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #snapshots,
          [],
          {#includeMetadataChanges: includeMetadataChanges},
        ),
        returnValue: _i5.Stream<_i4.DocumentSnapshot<T>>.empty(),
      ) as _i5.Stream<_i4.DocumentSnapshot<T>>);
  @override
  _i5.Future<void> set(
    T? data, [
    _i3.SetOptions? options,
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
  _i4.DocumentReference<R> withConverter<R>({
    required _i4.FromFirestore<R>? fromFirestore,
    required _i4.ToFirestore<R>? toFirestore,
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
        returnValue: _FakeDocumentReference_7<R>(
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
      ) as _i4.DocumentReference<R>);
}

/// A class which mocks [DocumentSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocumentSnapshot<T extends Object?> extends _i1.Mock
    implements _i4.DocumentSnapshot<T> {
  MockDocumentSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id => (super.noSuchMethod(
        Invocation.getter(#id),
        returnValue: '',
      ) as String);
  @override
  _i4.DocumentReference<T> get reference => (super.noSuchMethod(
        Invocation.getter(#reference),
        returnValue: _FakeDocumentReference_7<T>(
          this,
          Invocation.getter(#reference),
        ),
      ) as _i4.DocumentReference<T>);
  @override
  _i4.SnapshotMetadata get metadata => (super.noSuchMethod(
        Invocation.getter(#metadata),
        returnValue: _FakeSnapshotMetadata_11(
          this,
          Invocation.getter(#metadata),
        ),
      ) as _i4.SnapshotMetadata);
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

/// A class which mocks [Query].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockQuery<T extends Object?> extends _i1.Mock implements _i4.Query<T> {
  MockQuery() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_9(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i4.FirebaseFirestore);
  @override
  Map<String, dynamic> get parameters => (super.noSuchMethod(
        Invocation.getter(#parameters),
        returnValue: <String, dynamic>{},
      ) as Map<String, dynamic>);
  @override
  _i4.Query<T> endAtDocument(_i4.DocumentSnapshot<Object?>? documentSnapshot) =>
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> endAt(Iterable<Object?>? values) => (super.noSuchMethod(
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> endBeforeDocument(
          _i4.DocumentSnapshot<Object?>? documentSnapshot) =>
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> endBefore(Iterable<Object?>? values) => (super.noSuchMethod(
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
      ) as _i4.Query<T>);
  @override
  _i5.Future<_i4.QuerySnapshot<T>> get([_i3.GetOptions? options]) =>
      (super.noSuchMethod(
        Invocation.method(
          #get,
          [options],
        ),
        returnValue:
            _i5.Future<_i4.QuerySnapshot<T>>.value(_FakeQuerySnapshot_5<T>(
          this,
          Invocation.method(
            #get,
            [options],
          ),
        )),
      ) as _i5.Future<_i4.QuerySnapshot<T>>);
  @override
  _i4.Query<T> limit(int? limit) => (super.noSuchMethod(
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> limitToLast(int? limit) => (super.noSuchMethod(
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
      ) as _i4.Query<T>);
  @override
  _i5.Stream<_i4.QuerySnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #snapshots,
          [],
          {#includeMetadataChanges: includeMetadataChanges},
        ),
        returnValue: _i5.Stream<_i4.QuerySnapshot<T>>.empty(),
      ) as _i5.Stream<_i4.QuerySnapshot<T>>);
  @override
  _i4.Query<T> orderBy(
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> startAfterDocument(
          _i4.DocumentSnapshot<Object?>? documentSnapshot) =>
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> startAfter(Iterable<Object?>? values) => (super.noSuchMethod(
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> startAtDocument(
          _i4.DocumentSnapshot<Object?>? documentSnapshot) =>
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> startAt(Iterable<Object?>? values) => (super.noSuchMethod(
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<T> where(
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
      ) as _i4.Query<T>);
  @override
  _i4.Query<R> withConverter<R>({
    required _i4.FromFirestore<R>? fromFirestore,
    required _i4.ToFirestore<R>? toFirestore,
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
        returnValue: _FakeQuery_6<R>(
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
      ) as _i4.Query<R>);
  @override
  _i4.AggregateQuery count() => (super.noSuchMethod(
        Invocation.method(
          #count,
          [],
        ),
        returnValue: _FakeAggregateQuery_12(
          this,
          Invocation.method(
            #count,
            [],
          ),
        ),
      ) as _i4.AggregateQuery);
}

/// A class which mocks [QuerySnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuerySnapshot<T extends Object?> extends _i1.Mock
    implements _i4.QuerySnapshot<T> {
  MockQuerySnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i4.QueryDocumentSnapshot<T>> get docs => (super.noSuchMethod(
        Invocation.getter(#docs),
        returnValue: <_i4.QueryDocumentSnapshot<T>>[],
      ) as List<_i4.QueryDocumentSnapshot<T>>);
  @override
  List<_i4.DocumentChange<T>> get docChanges => (super.noSuchMethod(
        Invocation.getter(#docChanges),
        returnValue: <_i4.DocumentChange<T>>[],
      ) as List<_i4.DocumentChange<T>>);
  @override
  _i4.SnapshotMetadata get metadata => (super.noSuchMethod(
        Invocation.getter(#metadata),
        returnValue: _FakeSnapshotMetadata_11(
          this,
          Invocation.getter(#metadata),
        ),
      ) as _i4.SnapshotMetadata);
  @override
  int get size => (super.noSuchMethod(
        Invocation.getter(#size),
        returnValue: 0,
      ) as int);
}

/// A class which mocks [MockSpec].
///
/// See the documentation for Mockito's code generation for more information.
class MockMockSpec<T> extends _i1.Mock implements _i7.MockSpec<T> {
  MockMockSpec() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<Type> get mixins => (super.noSuchMethod(
        Invocation.getter(#mixins),
        returnValue: <Type>[],
      ) as List<Type>);
  @override
  Set<Symbol> get unsupportedMembers => (super.noSuchMethod(
        Invocation.getter(#unsupportedMembers),
        returnValue: <Symbol>{},
      ) as Set<Symbol>);
  @override
  Map<Symbol, Function> get fallbackGenerators => (super.noSuchMethod(
        Invocation.getter(#fallbackGenerators),
        returnValue: <Symbol, Function>{},
      ) as Map<Symbol, Function>);
}
