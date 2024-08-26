import 'package:asignment_9_google_map/Presentation/ui/controllers/map_controller.dart';
import 'package:get/get.dart';

class ControllerBindings implements Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => MapController());

  }
}
