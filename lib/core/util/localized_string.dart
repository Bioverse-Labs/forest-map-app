import 'package:easy_localization/easy_localization.dart';

abstract class LocalizedString {
  String getLocalizedString(String identifier,
      {Map<String, String>? namedArgs});
}

class LocalizedStringImpl implements LocalizedString {
  @override
  String getLocalizedString(
    String identifier, {
    Map<String, String>? namedArgs,
  }) =>
      identifier.tr(namedArgs: namedArgs);
}
