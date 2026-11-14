import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/bindings/initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final binding = await InitialBinding.create(installDevSeed: kDebugMode);
  runApp(MualimiApp(initialBinding: binding));
}
