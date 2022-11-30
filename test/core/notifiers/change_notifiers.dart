import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> expectToNotifiyListener<T extends ChangeNotifier>(
  T changeNotifier,
  Function() testFunction,
  List<NotifierAssertParams<T>> assertParams,
) async {
  Map<int, bool> results = {};

  int i = 0;
  changeNotifier.addListener(() {
    if (i < assertParams.length) {
      final value = assertParams[i].value(changeNotifier);
      expect(value, assertParams[i].matcher);
      i++;
    }
  });

  await testFunction();

  expect(i, assertParams.length);
  return results;
}

class NotifierAssertParams<T> {
  final Function(T) value;
  final dynamic matcher;

  NotifierAssertParams({
    @required this.value,
    @required this.matcher,
  });
}
