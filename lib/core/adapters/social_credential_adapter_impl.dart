import 'package:firebase_auth/firebase_auth.dart';
import 'package:forest_map/core/domain/adapters/social_credential_adapter.dart';
import 'package:forest_map/core/domain/entities/auth.dart';

class SocialCredentialAdapterImpl implements SocialCredentialAdapter {
  @override
  Future<Auth> getFacebookCredential(String token) async {
    final credential = FacebookAuthProvider.credential(token);

    return Auth(
      providerId: credential.providerId,
      signInMethod: credential.signInMethod,
      token: credential.token,
      accessToken: credential.accessToken,
    );
  }

  @override
  Future<Auth> getGoogleCredential(
    String? accessToken,
    String? idToken,
  ) async {
    final credential = GoogleAuthProvider.credential(
        accessToken: accessToken, idToken: idToken);

    return Auth(
      providerId: credential.providerId,
      signInMethod: credential.signInMethod,
      token: credential.token,
      accessToken: credential.accessToken,
    );
  }
}
