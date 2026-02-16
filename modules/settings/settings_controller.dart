import 'package:get/get.dart';

import '../../core/models/color_palette.dart';
import '../../core/models/font_option.dart';
import '../../core/services/settings_service.dart';

class SettingsController extends GetxController {
  final SettingsService settingsService;

  SettingsController({required this.settingsService});

  List<ColorPalette> get palettes => ColorPalette.palettes;
  List<FontOption> get fonts => FontOption.fonts;

  void selectPalette(int index) {
    settingsService.setPalette(index);
    settingsService.update(); // Atualiza o GetBuilder no App
  }

  void selectFont(int index) {
    settingsService.setFont(index);
    settingsService.update(); // Atualiza o GetBuilder no App
  }

  void selectBibleTranslation(String translation) {
    settingsService.setBibleTranslation(translation);
    settingsService.update();
  }
}
