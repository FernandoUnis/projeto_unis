import 'package:get/get.dart';
import '../../models/biblia_models.dart';

class CapitulosController extends GetxController {
  late final Livro livro;

  @override
  void onInit() {
    super.onInit();
    livro = Get.arguments as Livro;
  }

  void navegarParaVersiculos(Capitulo capitulo) {
    if (capitulo.versiculos.isNotEmpty) {
      Get.toNamed('/versiculos', arguments: {'livro': livro, 'capitulo': capitulo});
    }
  }
}

