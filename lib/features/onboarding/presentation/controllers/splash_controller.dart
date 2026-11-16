import 'package:get/get.dart';

import '../../domain/usecases/get_start_route_usecase.dart';
import 'splash_timing.dart';

class SplashController extends GetxController {
  SplashController(this._getStartRoute, {Duration minDisplay = SplashTiming.minDisplay})
      : _minDisplay = minDisplay;
  final GetStartRouteUseCase _getStartRoute;
  final Duration _minDisplay;

  @override
  void onReady() {
    super.onReady();
    _goNext();
  }

  /// The check and the minimum delay run in parallel, so the wait is
  /// max(check, [_minDisplay]), never their sum.
  Future<void> _goNext() async {
    final (route, _) = await (_getStartRoute(), Future<void>.delayed(_minDisplay)).wait;
    Get.offAllNamed<void>(route);
  }
}
