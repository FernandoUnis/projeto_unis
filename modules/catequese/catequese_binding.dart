import 'package:get/get.dart';

import 'catequese_controller.dart';

class CatequeseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatequeseController>(() => CatequeseController());
  }
}
