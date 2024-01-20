import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  const Auth({
    required this.providerId,
    required this.signInMethod,
    this.token,
    this.accessToken,
  });

  /// The authentication provider ID for the credential. For example,
  /// 'facebook.com', or 'google.com'.
  final String providerId;

  /// The authentication sign in method for the credential. For example,
  /// 'password', or 'emailLink'. This corresponds to the sign-in method
  /// identifier returned in [fetchSignInMethodsForEmail].
  final String signInMethod;

  /// A token used to identify the AuthCredential on native platforms.
  final int? token;

  /// The OAuth access token associated with the credential if it belongs to an
  /// OAuth provider, such as `facebook.com`, `twitter.com`, etc.
  /// Using the OAuth access token, you can call the provider's API.
  final String? accessToken;

  @override
  List<Object?> get props => [
        providerId,
        signInMethod,
        token,
        accessToken,
      ];
}
