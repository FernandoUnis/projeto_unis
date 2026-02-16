import 'package:get/get.dart';

import 'liturgia_controller.dart';

class LiturgiaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiturgiaController>(() {
      return LiturgiaController();
    });
  }
}
