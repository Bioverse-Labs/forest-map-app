import 'package:forest_map/core/domain/entities/auth.dart';

abstract class SocialCredentialAdapter {
  Future<Auth> getFacebookCredential(String token);
  Future<Auth> getGoogleCredential(String? accessToken, String? idToken);
}
