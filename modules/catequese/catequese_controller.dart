import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/catechism_models.dart';

class CatequeseController extends GetxController {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final _chapter = Rxn<CatechismChapter>();
  CatechismChapter? get chapter => _chapter.value;

  final _carregando = true.obs;
  bool get carregando => _carregando.value;

  final _catecismo = Rxn<Catechism>();
  Catechism? get catecismo => _catecismo.value;

  final _erro = RxnString();
  String? get erro => _erro.value;

  final _lastParagraphNumber = 0.obs;
  int get lastParagraphNumber => _lastParagraphNumber.value;

  final _fontSize = 18.0.obs;
  double get fontSize => _fontSize.value;

  final _fontFamily = 'OpenSans'.obs;
  String get fontFamily => _fontFamily.value;

  final _showFontSettings = false.obs;
  bool get showFontSettings => _showFontSettings.value;

  static const String _lastPosKey = 'ultimo_paragrafo_catecismo';
  static const String _fontSizeKey = 'catequese_font_size';
  static const String _fontFamilyKey = 'catequese_font_family';

  @override
  void onInit() {
    super.onInit();
    carregarCatecismo();
    _loadSettings();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    itemPositionsListener.itemPositions.addListener(() {
      if (_chapter.value == null) return;

      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstItem = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce(
              (ItemPosition min, ItemPosition position) =>
                  position.itemLeadingEdge < min.itemLeadingEdge
                  ? position
                  : min,
            );

        if (firstItem.index >= 0 &&
            firstItem.index < _chapter.value!.paragraphs.length) {
          final paragraphNumber =
              _chapter.value!.paragraphs[firstItem.index].number;
          salvarPosicao(paragraphNumber);
        }
      }
    });
  }

  void initReading(dynamic args) {
    if (args is CatechismChapter) {
      _chapter.value = args;
    } else if (args is Map) {
      _chapter.value = args['chapter'] as CatechismChapter?;
      final initialParagraph = args['initialParagraph'] as int?;

      if (_chapter.value != null && initialParagraph != null) {
        // We need to wait for the list to be built
        Future.delayed(const Duration(milliseconds: 100), () {
          final index = _chapter.value!.paragraphs.indexWhere(
            (p) => p.number == initialParagraph,
          );
          if (index != -1) {
            itemScrollController.jumpTo(index: index);
          }
        });
      }
    }
  }

  Future<void> carregarCatecismo() async {
    try {
      _carregando.value = true;
      _erro.value = null;

      final String response = await rootBundle.loadString(
        'assets/data/catechism_po.json',
      );
      final data = await json.decode(response);
      _catecismo.value = Catechism.fromJson(data);
    } catch (e) {
      _erro.value = e.toString();
    } finally {
      _carregando.value = false;
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _lastParagraphNumber.value = prefs.getInt(_lastPosKey) ?? 0;
    _fontSize.value = prefs.getDouble(_fontSizeKey) ?? 18.0;
    _fontFamily.value = prefs.getString(_fontFamilyKey) ?? 'OpenSans';
  }

  Future<void> salvarPosicao(int paragraphNumber) async {
    _lastParagraphNumber.value = paragraphNumber;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastPosKey, paragraphNumber);
  }

  void updateFontSize(double size) async {
    _fontSize.value = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  void updateFontFamily(String family) async {
    _fontFamily.value = family;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, family);
  }

  void toggleFontSettings() {
    _showFontSettings.value = !_showFontSettings.value;
  }

  void recarregar() => carregarCatecismo();

  // Helper to find path to a paragraph
  String getHierarchyLabel(int paragraphNumber) {
    if (catecismo == null) return '';
    for (var part in catecismo!.parts) {
      for (var section in part.sections) {
        for (var chapter in section.chapters) {
          if (chapter.paragraphs.any((p) => p.number == paragraphNumber)) {
            return '${part.title} > ${section.title} > ${chapter.title}';
          }
        }
      }
      for (var chapter in part.chapters) {
        if (chapter.paragraphs.any((p) => p.number == paragraphNumber)) {
          return '${part.title} > ${chapter.title}';
        }
      }
    }
    return '';
  }
}
