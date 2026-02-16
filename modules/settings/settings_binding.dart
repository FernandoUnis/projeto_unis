import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import 'settings_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        settingsService: Get.find<SettingsService>(),
      ),
    );
  }
}
