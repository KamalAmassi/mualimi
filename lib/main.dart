import 'package:flutter/material.dart';

import 'app.dart';
import 'core/bindings/initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final binding = await InitialBinding.create();
  runApp(MualimiApp(initialBinding: binding));
}
