import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  User({
    @required this.id,
    @required this.name,
    this.email,
    this.avatarUrl,
  });

  @override
  List<Object> get props => [id, name, email, avatarUrl];
}
