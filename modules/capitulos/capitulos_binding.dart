import 'package:get/get.dart';
import 'capitulos_controller.dart';

class CapitulosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CapitulosController());
  }
}

