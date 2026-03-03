import 'package:get/get.dart';
import '../search/search_controller.dart';
import 'main_shell_view.dart';
import '../home/home_binding.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(() => MainShellController());
    Get.lazyPut<SearchController>(() => SearchController());
    HomeBinding().dependencies();
  }
}
