import 'package:get/get.dart';
import 'package:lumen_caeli/core/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/repositories/biblia_repository.dart';
import '../../models/biblia_models.dart';
import '../../services/biblia_service.dart';

class LivrosController extends GetxController {
  final BibliaRepository repository;
  final SettingsService _settingsService = Get.find<SettingsService>();
  final Rx<Biblia?> _biblia = Rx<Biblia?>(null);
  final RxBool _carregando = true.obs;
  final Rxn<String> _erro = Rxn<String>();

  Biblia? get biblia => _biblia.value;
  bool get carregando => _carregando.value;
  String? get erro => _erro.value;

  final RxBool _isSearching = false.obs;
  final RxString _searchQuery = ''.obs;

  bool get isSearching => _isSearching.value;
  String get searchQuery => _searchQuery.value;

  final _lastReading = Rxn<Map<String, dynamic>>();
  Map<String, dynamic>? get lastReading => _lastReading.value;

  static const String _lastLibroKey = 'ultimo_livro_biblia';
  static const String _lastCapituloKey = 'ultimo_capitulo_biblia';
  static const String _lastVersiculoKey = 'ultimo_versiculo_biblia';

  LivrosController({required this.repository}); // Modified constructor

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Biblia) {
      _biblia.value = args;
      _carregando.value = false;
    } else {
      _carregarBiblia();
    }
    _loadLastReading();

    // Listen to translation changes to reload the Bible
    ever(_settingsService.selectedBibleTranslation, (_) {
      _carregarBiblia();
    });
  }

  Future<void> _loadLastReading() async {
    final prefs = await SharedPreferences.getInstance();
    final libroNome = prefs.getString(_lastLibroKey);
    final capituloNumero = prefs.getInt(_lastCapituloKey);
    final versiculoNumero = prefs.getInt(_lastVersiculoKey);

    if (libroNome != null && capituloNumero != null) {
      _lastReading.value = {
        'libro': libroNome,
        'capitulo': capituloNumero,
        'versiculo': versiculoNumero,
      };
    }
  }

  Future<void> limparUltimaLeitura() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastLibroKey);
    await prefs.remove(_lastCapituloKey);
    await prefs.remove(_lastVersiculoKey);
    _lastReading.value = null;
  }

  void navegarParaUltimaLeitura() async {
    if (lastReading == null || biblia == null) return;

    final libroNome = lastReading!['libro'];
    final capituloNumero = lastReading!['capitulo'];
    final versiculoNumero = lastReading!['versiculo'];

    // Find the libro and capitulo objects
    Livro? targetLivro;
    for (var cat in biblia!.antigoTestamento.categorias) {
      targetLivro = cat.livros.firstWhereOrNull((l) => l.nome == libroNome);
      if (targetLivro != null) break;
    }
    if (targetLivro == null) {
      for (var cat in biblia!.novoTestamento.categorias) {
        targetLivro = cat.livros.firstWhereOrNull((l) => l.nome == libroNome);
        if (targetLivro != null) break;
      }
    }

    if (targetLivro != null) {
      final targetCapitulo = targetLivro.capitulos.firstWhereOrNull(
        (c) => c.numero == capituloNumero,
      );

      if (targetCapitulo != null) {
        await Get.toNamed(
          '/versiculos',
          arguments: {
            'livro': targetLivro,
            'capitulo': targetCapitulo,
            'versiculo': versiculoNumero,
          },
        );
        await _loadLastReading();
      }
    }
  }

  void toggleSearch() {
    _isSearching.value = !_isSearching.value;
    if (!_isSearching.value) {
      _searchQuery.value = '';
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  List<CategoriaLivros> getFilteredCategorias(TestamentoBase testamento) {
    if (searchQuery.isEmpty) {
      return testamento.categorias;
    }

    final query = searchQuery.toLowerCase();
    return testamento.categorias
        .map((cat) {
          final filteredLivros = cat.livros.where((livro) {
            return livro.nome.toLowerCase().contains(query) ||
                livro.abreviacao.toLowerCase().contains(query);
          }).toList();

          if (filteredLivros.isEmpty) return null;

          return CategoriaLivros(nome: cat.nome, livros: filteredLivros);
        })
        .whereType<CategoriaLivros>()
        .toList();
  }

  Future<void> _carregarBiblia() async {
    try {
      _carregando.value = true;
      _erro.value = null;

      // Tenta pegar do cache do serviço primeiro
      final bibliaCache = BibliaService.biblia;
      final selectedTranslation =
          _settingsService.selectedBibleTranslation.value;

      if (bibliaCache != null && bibliaCache.versao == selectedTranslation) {
        _biblia.value = bibliaCache;
        _carregando.value = false;
        return;
      }

      // Se não tiver no cache, carrega usando o serviço
      final biblia = await BibliaService.carregarBiblia();
      _biblia.value = biblia;
      _erro.value = null;
    } catch (e) {
      _erro.value = e.toString();
    } finally {
      _carregando.value = false;
    }
  }

  void recarregar() {
    _carregarBiblia();
  }

  Future<void> navegarParaCapitulos(Livro livro) async {
    await Get.toNamed('/capitulos', arguments: livro);
    await _loadLastReading();
  }
}
