import 'package:asignment_9_google_map/Presentation/ui/screens/google_map_screen.dart';
import 'package:asignment_9_google_map/routes/routes_name.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() {
    return [
      GetPage(
        name: RoutesName.googleMapScreen,
        page: () => const GoogleMapScreen(),
        transitionDuration: const Duration(seconds: 3),
        transition: Transition.leftToRightWithFade,
      ),
    ];
  }
}
