import 'package:get/get.dart';

import '../../domain/usecases/get_start_route_usecase.dart';

class SplashController extends GetxController {
  SplashController(this._getStartRoute);
  final GetStartRouteUseCase _getStartRoute;

  @override
  void onReady() {
    super.onReady();
    _goNext();
  }

  Future<void> _goNext() async {
    final route = await _getStartRoute();
    Get.offAllNamed<void>(route);
  }
}
