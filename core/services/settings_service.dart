import 'package:get/get.dart';

import '../models/color_palette.dart';
import '../models/font_option.dart';
import 'storage_service.dart';

class SettingsService extends GetxController {
  // Valores padrão
  static const int defaultPaletteIndex = 0;
  static const int defaultFontIndex = 0;

  // Observables
  final RxInt selectedPaletteIndex = defaultPaletteIndex.obs;
  final RxInt selectedFontIndex = defaultFontIndex.obs;
  final RxString selectedBibleTranslation = 'Ave Maria'.obs;

  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  @override
  void onClose() {
    // Cleanup se necessário
    super.onClose();
  }

  // Carrega as preferências salvas
  Future<void> loadPreferences() async {
    if (_isInitialized) return;

    try {
      // Carrega o índice da paleta
      final savedPaletteIndex = await StorageService.loadPaletteIndex();
      if (savedPaletteIndex != null &&
          savedPaletteIndex >= 0 &&
          savedPaletteIndex < ColorPalette.palettes.length) {
        selectedPaletteIndex.value = savedPaletteIndex;
      }

      // Carrega o índice da fonte
      final savedFontIndex = await StorageService.loadFontIndex();
      if (savedFontIndex != null &&
          savedFontIndex >= 0 &&
          savedFontIndex < FontOption.fonts.length) {
        selectedFontIndex.value = savedFontIndex;
      }

      // Carrega a tradução da Bíblia
      final savedTranslation = await StorageService.loadBibleTranslation();
      if (savedTranslation != null) {
        selectedBibleTranslation.value = savedTranslation;
      }

      _isInitialized = true;
      update(); // Notifica os listeners após carregar
    } catch (e) {
      // Em caso de erro, usa os valores padrão
      _isInitialized = true;
    }
  }

  ColorPalette get currentPalette {
    return ColorPalette.palettes[selectedPaletteIndex.value];
  }

  FontOption get currentFont {
    return FontOption.fonts[selectedFontIndex.value];
  }

  void setPalette(int index) {
    if (index >= 0 && index < ColorPalette.palettes.length) {
      selectedPaletteIndex.value = index;
      StorageService.savePaletteIndex(index); // Salva a preferência
      update(); // Notifica os listeners
    }
  }

  void setFont(int index) {
    if (index >= 0 && index < FontOption.fonts.length) {
      selectedFontIndex.value = index;
      StorageService.saveFontIndex(index); // Salva a preferência
      update(); // Notifica os listeners
    }
  }

  void setBibleTranslation(String translation) {
    selectedBibleTranslation.value = translation;
    StorageService.saveBibleTranslation(translation);
    update();
  }
}
