import 'package:equatable/equatable.dart';

import '../../../organization/domain/entities/organization.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final List<Organization>? organizations;

  User({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
    this.organizations = const <Organization>[],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        organizations,
      ];
}
