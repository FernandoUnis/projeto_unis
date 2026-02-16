import 'package:get/get.dart';

import '../../modules/capitulos/capitulos_binding.dart';
import '../../modules/capitulos/capitulos_page.dart';
import '../../modules/catequese/catequese_binding.dart';
import '../../modules/catequese/catequese_index_page.dart';
import '../../modules/catequese/catequese_reading_page.dart';
import '../../modules/home/home.dart';
import '../../modules/home/home_binding.dart';
import '../../modules/liturgia/liturgia_binding.dart';
import '../../modules/liturgia/liturgia_page.dart';
import '../../modules/livros/livros_binding.dart';
import '../../modules/livros/livros_page.dart';
import '../../modules/settings/settings_binding.dart';
import '../../modules/settings/settings_page.dart';
import '../../modules/versiculos/versiculos_binding.dart';
import '../../modules/versiculos/versiculos_page.dart';

class AppPages {
  static const String home = '/';
  static const String livros = '/livros';
  static const String capitulos = '/capitulos';
  static const String versiculos = '/versiculos';
  static const String settings = '/settings';
  static const String liturgia = '/liturgia';
  static const String catequese = '/catequese';
  static const String catequeseLeitura = '/catequese/leitura';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(
      name: livros,
      page: () => const LivrosPage(),
      binding: LivrosBinding(),
    ),
    GetPage(
      name: capitulos,
      page: () => const CapitulosPage(),
      binding: CapitulosBinding(),
    ),
    GetPage(
      name: versiculos,
      page: () => const VersiculosPage(),
      binding: VersiculosBinding(),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: liturgia,
      page: () => const LiturgiaPage(),
      binding: LiturgiaBinding(),
    ),
    GetPage(
      name: catequese,
      page: () => const CatequeseIndexPage(),
      binding: CatequeseBinding(),
    ),
    GetPage(
      name: catequeseLeitura,
      page: () => const CatequeseReadingPage(),
      binding: CatequeseBinding(),
    ),
  ];
}
