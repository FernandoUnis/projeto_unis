import 'package:get/get.dart';
import 'versiculos_controller.dart';

class VersiculosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VersiculosController());
  }
}

