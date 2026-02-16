import 'package:get/get.dart';
import 'package:lumen_caeli/core/repositories/biblia_repository.dart';

import 'livros_controller.dart';

class LivrosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LivrosController>(
      () => LivrosController(repository: Get.find<BibliaRepository>()),
    );
  }
}
