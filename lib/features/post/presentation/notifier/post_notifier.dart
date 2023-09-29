import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../catalog/domain/entities/catalog.dart';
import '../../data/hive/pending_post.dart';
import '../../domain/usecases/get_posts.dart';

import '../../../../core/adapters/hive_adapter.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/save_post.dart';
import '../../domain/usecases/upload_cached_post.dart';

abstract class PostNotifier {
  Future<void> savePost({
    String? organizationId,
    String? userId,
    File? file,
    Catalog? category,
  });
  Future<void> uploadCachedPost();
  Future<void> getPosts(String? orgId);
}

class PostNotifierImpl extends ChangeNotifier implements PostNotifier {
  final SavePost? savePostUseCase;
  final UploadCachedPost? uploadCachedPostUseCase;
  final GetPosts? getPostsUseCase;
  final HiveAdapter<PendingPostHive>? postHive;

  bool _loading = false;
  StreamController<Either<Failure, Post>>? _controller;
  int _cachedPostsLength = 0;
  int _cachedPostsUploadedAmount = 0;
  List<Post> _posts = [];

  PostNotifierImpl({
    required this.savePostUseCase,
    required this.uploadCachedPostUseCase,
    required this.postHive,
    required this.getPostsUseCase,
  });

  Stream<Either<Failure, Post>> get stream =>
      _controller!.stream.asBroadcastStream();
  StreamController<Either<Failure, Post>>? get streamController => _controller;
  bool get isLoading => _loading;
  int get cachedPostsAmount => _cachedPostsLength;
  int get postsAmount => _cachedPostsUploadedAmount;
  List<Post> get posts => _posts;

  @override
  Future<void> savePost({
    String? organizationId,
    String? userId,
    File? file,
    Catalog? category,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrPosts = await savePostUseCase!(SavePostParams(
      userId: userId,
      organizationId: organizationId,
      file: file,
      category: category,
    ));

    _loading = false;
    notifyListeners();

    failureOrPosts.fold(
      (failure) => throw failure,
      (posts) {
        _posts = posts;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> uploadCachedPost() async {
    final keys = postHive!.getKeys();
    if (keys.length > 0) {
      _loading = true;
      _cachedPostsLength = keys.length;
      _cachedPostsUploadedAmount = 0;
      notifyListeners();

      final failureOrStream = await uploadCachedPostUseCase!(NoParams());

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
                  _controller!.close();
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

  @override
  Future<void> getPosts(String? orgId) async {
    _loading = true;
    notifyListeners();

    final failureOrPosts = await getPostsUseCase!(GetPostsParams(orgId));

    _loading = false;
    notifyListeners();

    failureOrPosts.fold(
      (failure) => throw failure,
      (posts) {
        _posts = posts;
        notifyListeners();
      },
    );
  }

  void cancelUpload() {
    streamController?.close();
    _cachedPostsUploadedAmount = _cachedPostsLength;
    notifyListeners();
  }
}
