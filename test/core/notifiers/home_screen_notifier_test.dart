import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/notifiers/home_screen_notifier.dart';

import 'change_notifiers.dart';

void main() {
  HomeScreenNotifierImpl homeScreenNotifierImpl;

  setUp(() {
    homeScreenNotifierImpl = HomeScreenNotifierImpl();
  });

  test(
    'should update index',
    () async {
      await expectToNotifiyListener<HomeScreenNotifierImpl>(
        homeScreenNotifierImpl,
        () => homeScreenNotifierImpl.setActiveTab(1),
        [
          NotifierAssertParams(
            value: (notifier) => notifier.activeTabIndex,
            matcher: 1,
          ),
        ],
      );
    },
  );
}
