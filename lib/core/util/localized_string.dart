import 'package:easy_localization/easy_localization.dart';

abstract class LocalizedString {
  String getLocalizedString(String identifier);
}

class LocalizedStringImpl implements LocalizedString {
  @override
  String getLocalizedString(String identifier) => identifier.tr();
}
