import 'package:get/get.dart';

import '../../core/services/settings_service.dart';
import '../../models/liturgia_models.dart';
import '../../services/liturgia_service.dart';

class HomeController extends GetxController {
  final SettingsService settingsService = Get.find<SettingsService>();
  final _carregando = false.obs;
  final _erro = Rxn<String>();
  final _liturgiaHoje = Rxn<LiturgiaDiaria>();
  final _salmoTexto = Rxn<String>();
  final _carregandoSalmo = false.obs;

  bool get carregando => _carregando.value;
  String? get erro => _erro.value;
  LiturgiaDiaria? get liturgiaHoje => _liturgiaHoje.value;
  String? get salmoTexto => _salmoTexto.value;
  bool get carregandoSalmo => _carregandoSalmo.value;

  @override
  void onInit() {
    super.onInit();
    _carregarDados();

    // Listen to Bible translation changes to reload the psalm
    ever(settingsService.selectedBibleTranslation, (_) {
      _carregarDados();
    });
  }

  Future<void> _carregarDados() async {
    try {
      _carregando.value = true;

      // Carrega a liturgia de hoje
      final liturgia = await LiturgiaService.liturgiaHoje;
      _liturgiaHoje.value = liturgia;

      // Se tem salmo, usa o texto do calendário litúrgico ou busca da Bíblia
      if (liturgia?.salmo != null) {
        await _carregarSalmo(liturgia!);
      }

      _erro.value = null;
    } catch (e) {
      _erro.value = e.toString();
    } finally {
      _carregando.value = false;
    }
  }

  Future<void> _carregarSalmo(LiturgiaDiaria liturgia) async {
    try {
      _carregandoSalmo.value = true;

      // Primeiro tenta usar o texto do salmo do calendário litúrgico
      if (liturgia.salmoTexto != null && liturgia.salmoTexto!.isNotEmpty) {
        _salmoTexto.value = liturgia.salmoTexto;
        return;
      }

      // Se tem refrão, mostra o refrão como texto principal
      if (liturgia.salmoRefrao != null && liturgia.salmoRefrao!.isNotEmpty) {
        _salmoTexto.value = 'R. ${liturgia.salmoRefrao}';
        return;
      }

      // Fallback: tenta buscar da Bíblia (pode não funcionar com formato litúrgico)
      final texto = await LiturgiaService.buscarTextoLeitura(liturgia.salmo!);
      _salmoTexto.value = texto;
    } catch (e) {
      _salmoTexto.value = null;
    } finally {
      _carregandoSalmo.value = false;
    }
  }

  void recarregar() {
    _carregarDados();
  }
}
