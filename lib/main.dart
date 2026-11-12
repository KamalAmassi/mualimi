import 'package:flutter/material.dart';

import 'app.dart';
import 'core/bindings/initial_binding.dart';
import 'features/curriculum_tutor/data/datasources/gemma_bootstrap.dart';
import 'features/curriculum_tutor/data/datasources/gemma_runtime.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final binding = await InitialBinding.create(runtime: GemmaRuntime(GemmaBootstrap()));
  runApp(MualimiApp(initialBinding: binding));
}
