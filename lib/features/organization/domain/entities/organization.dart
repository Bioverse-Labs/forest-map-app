import 'package:equatable/equatable.dart';
import 'package:forestMapApp/features/map/domain/entities/geolocation_data.dart';
import 'package:meta/meta.dart';

import 'member.dart';

class Organization extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final List<Member> members;
  final List<GeolocationData> geolocationData;

  Organization({
    @required this.id,
    @required this.name,
    @required this.email,
    this.phone,
    this.avatarUrl,
    this.members,
    this.geolocationData,
  });

  @override
  List<Object> get props => [id, name, email, phone, avatarUrl, members];
}
