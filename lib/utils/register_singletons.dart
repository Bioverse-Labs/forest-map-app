import 'package:forestMapApp/utils/app_navigator.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

void registerSingletons() {
  GetIt.I.registerLazySingleton<AppNavigator>(() => AppNavigator());
  GetIt.I.registerLazySingleton<ImagePicker>(() => ImagePicker());
}
