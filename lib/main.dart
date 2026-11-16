import 'package:flutter/material.dart';

import 'app.dart';
import 'core/bindings/initial_binding.dart';
import 'core/db/content/seed/dev_seed_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final binding = await InitialBinding.create(
    installDevSeed: DevSeedLoader.isEnabled(),
  );
  runApp(MualimiApp(initialBinding: binding));
}
