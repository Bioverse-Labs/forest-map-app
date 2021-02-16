import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/hive/post.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/save_post.dart';
import '../../domain/usecases/upload_cached_post.dart';

abstract class PostNotifier {
  Future<void> savePost({
    String organizationId,
    String userId,
    File file,
    String specie,
  });
  Future<void> uploadCachedPost();
}

class PostNotifierImpl extends ChangeNotifier implements PostNotifier {
  final SavePost savePostUseCase;
  final UploadCachedPost uploadCachedPostUseCase;
  final HiveAdapter<PostHive> postHive;

  bool _loading = false;
  StreamController<Either<Failure, Post>> _controller;
  int _cachedPostsLength = 0;
  int _cachedPostsUploadedAmount = 0;

  PostNotifierImpl({
    @required this.savePostUseCase,
    @required this.uploadCachedPostUseCase,
    @required this.postHive,
  });

  Stream<Either<Failure, Post>> get stream =>
      _controller.stream.asBroadcastStream();
  StreamController<Either<Failure, Post>> get streamController => _controller;
  bool get isLoading => _loading;
  int get cachedPostsAmount => _cachedPostsLength;
  int get postsAmount => _cachedPostsUploadedAmount;

  @override
  Future<void> savePost({
    String organizationId,
    String userId,
    File file,
    String specie,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrVoid = await savePostUseCase(SavePostParams(
      userId: userId,
      organizationId: organizationId,
      file: file,
      specie: specie,
    ));

    _loading = false;
    notifyListeners();

    failureOrVoid.fold(
      (failure) => throw failure,
      (r) => r,
    );
  }

  @override
  Future<void> uploadCachedPost() async {
    final keys = postHive.getKeys();
    if (keys.length > 0) {
      _loading = true;
      _cachedPostsLength = keys.length;
      _cachedPostsUploadedAmount = 0;
      notifyListeners();

      final failureOrStream = await uploadCachedPostUseCase(NoParams());

      _loading = false;
      notifyListeners();

      failureOrStream.fold(
        (failure) => throw failure,
        (controller) {
          _controller = controller;
          stream.listen((failureOrPost) {
            failureOrPost.fold(
              (failure) {
                if (failure is NoInternetFailure) {
                  _controller.close();
                  _cachedPostsUploadedAmount = _cachedPostsLength;
                  notifyListeners();
                }
              },
              (_) {
                _cachedPostsUploadedAmount++;
                notifyListeners();
              },
            );
          });
          notifyListeners();
        },
      );
    }
  }

  void cancelUpload() {
    streamController?.close();
    _cachedPostsUploadedAmount = _cachedPostsLength;
    notifyListeners();
  }
}
