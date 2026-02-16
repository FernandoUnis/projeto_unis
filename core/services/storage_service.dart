import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyPaletteIndex = 'selected_palette_index';
  static const String _keyFontIndex = 'selected_font_index';
  static const String _keyBibleTranslation = 'selected_bible_translation';

  // Salva o índice da paleta selecionada
  static Future<bool> savePaletteIndex(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_keyPaletteIndex, index);
    } catch (e) {
      return false;
    }
  }

  // Carrega o índice da paleta selecionada
  static Future<int?> loadPaletteIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyPaletteIndex);
    } catch (e) {
      return null;
    }
  }

  // Salva o índice da fonte selecionada
  static Future<bool> saveFontIndex(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(_keyFontIndex, index);
    } catch (e) {
      return false;
    }
  }

  // Carrega o índice da fonte selecionada
  static Future<int?> loadFontIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyFontIndex);
    } catch (e) {
      return null;
    }
  }

  // Salva a tradução da Bíblia selecionada
  static Future<bool> saveBibleTranslation(String translation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_keyBibleTranslation, translation);
    } catch (e) {
      return false;
    }
  }

  // Carrega a tradução da Bíblia selecionada
  static Future<String?> loadBibleTranslation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyBibleTranslation);
    } catch (e) {
      return null;
    }
  }

  // Limpa todas as preferências salvas
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      return false;
    }
  }
}
