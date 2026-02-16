import 'package:get/get.dart';
import 'package:lumen_caeli/core/repositories/biblia_repository.dart';
import 'package:lumen_caeli/core/services/settings_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SettingsService>(SettingsService(), permanent: true);
    Get.put<BibliaRepository>(BibliaRepositoryImpl(), permanent: true);
  }
}
