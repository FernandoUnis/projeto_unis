import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/biblia_models.dart';

class VersiculosController extends GetxController {
  late final Livro livro;
  late final Capitulo capitulo;

  final ScrollController scrollController = ScrollController();
  final _currentVerse = 1.obs;
  int get currentVerse => _currentVerse.value;

  final _showScrollIndicator = false.obs;
  bool get showScrollIndicator => _showScrollIndicator.value;

  final _fontSize = 16.0.obs;
  double get fontSize => _fontSize.value;

  final _fontFamily = 'OpenSans'.obs;
  String get fontFamily => _fontFamily.value;

  final _showFontSettings = false.obs;
  bool get showFontSettings => _showFontSettings.value;

  static const String _lastLibroKey = 'ultimo_livro_biblia';
  static const String _lastCapituloKey = 'ultimo_capitulo_biblia';
  static const String _lastVersiculoKey = 'ultimo_versiculo_biblia';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    livro = args['livro'] as Livro;
    capitulo = args['capitulo'] as Capitulo;

    // Listen to verse changes to save position
    debounce(
      _currentVerse,
      (_) => _saveReadingPosition(),
      time: const Duration(seconds: 2),
    );

    _saveReadingPosition();

    // Scroll to initial verse if provided
    if (args.containsKey('versiculo')) {
      final initialVerse = args['versiculo'] as int;
      _currentVerse.value = initialVerse;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse(initialVerse);
      });
    }
  }

  void _scrollToVerse(int verseNumber) {
    if (!scrollController.hasClients) return;
    final index = capitulo.versiculos.indexWhere(
      (v) => v.numero == verseNumber,
    );
    if (index != -1) {
      // Approximate calculation, since verses have different heights
      // In a real scenario, we might use Scrollable.ensureVisible with GlobalKeys
      const averageHeight = 85.0;
      scrollController.animateTo(
        index * averageHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveReadingPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLibroKey, livro.nome);
    await prefs.setInt(_lastCapituloKey, capitulo.numero);
    await prefs.setInt(_lastVersiculoKey, _currentVerse.value);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void onScrollNotification(ScrollNotification notification) {
    if (!scrollController.hasClients) return;

    if (notification is ScrollUpdateNotification) {
      _showScrollIndicator.value = true;
      final offset = scrollController.offset;
      const averageHeight = 80.0;
      int index = (offset / averageHeight).floor();
      if (index < 0) index = 0;
      if (index >= capitulo.versiculos.length)
        index = capitulo.versiculos.length - 1;
      _currentVerse.value = capitulo.versiculos[index].numero;
    } else if (notification is ScrollEndNotification) {
      // Hide indicator after a delay? Or just keep it.
      Future.delayed(const Duration(seconds: 2), () {
        _showScrollIndicator.value = false;
      });
    }
  }

  void updateCurrentVerse(int index) {
    _currentVerse.value = index + 1;
  }

  void updateFontSize(double size) {
    _fontSize.value = size;
  }

  void updateFontFamily(String family) {
    _fontFamily.value = family;
  }

  void toggleFontSettings() {
    _showFontSettings.value = !_showFontSettings.value;
  }
}
