import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
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

  bool _loading = false;
  StreamController<Either<Failure, Post>> _controller;

  PostNotifierImpl({
    @required this.savePostUseCase,
    @required this.uploadCachedPostUseCase,
  });

  Stream<Either<Failure, Post>> get stream =>
      _controller.stream.asBroadcastStream();
  StreamController<Either<Failure, Post>> get streamController => _controller;
  bool get isLoading => _loading;

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
    _loading = true;
    notifyListeners();

    final failureOrStream = await uploadCachedPostUseCase(NoParams());

    _loading = false;
    notifyListeners();

    failureOrStream.fold(
      (failure) => throw failure,
      (controller) {
        _controller = controller;
        notifyListeners();
      },
    );
  }
}
