import 'dart:io';

import 'package:flutter/material.dart';

import '../../../organization/domain/entities/organization.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/update_user.dart';

abstract class UserNotifier {
  Future<void> getUser({
    required String id,
    bool? searchLocally,
  });
  Future<void> updateUser({
    String? id,
    String? name,
    String? email,
    List<Organization>? organizations,
    File? avatar,
  });
}

class UserNotifierImpl extends ChangeNotifier implements UserNotifier {
  final GetUser? getUserUseCase;
  final UpdateUser? updateUserUseCase;

  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get isLoading => _loading;

  UserNotifierImpl({
    required this.getUserUseCase,
    required this.updateUserUseCase,
  });

  @override
  Future<void> getUser({
    required String? id,
    bool? searchLocally = false,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrUser = await getUserUseCase!(GetUserParams(
      id: id,
      searchLocally: searchLocally,
    ));

    _loading = false;
    notifyListeners();

    failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        _user = user;
        notifyListeners();
      },
    );
  }

  @override
  Future<void> updateUser({
    String? id,
    String? name,
    String? email,
    List<Organization>? organizations,
    File? avatar,
  }) async {
    _loading = true;
    notifyListeners();

    final failureOrUser = await updateUserUseCase!(UpdateUserParams(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      organizations: organizations,
    ));

    _loading = false;
    notifyListeners();

    failureOrUser.fold(
      (failure) => throw failure,
      (user) {
        _user = user;
        notifyListeners();
      },
    );
  }
}
