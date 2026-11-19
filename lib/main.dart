import 'package:flutter/material.dart';

import 'app.dart';
import 'core/bindings/initial_binding.dart';
import 'core/db/content/seed/dev_seed_loader.dart';
import 'features/content_manager/data/datasources/pack_recovery.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final binding = await InitialBinding.create(
    installDevSeed: DevSeedLoader.isEnabled(),
    beforeContentOpen: (paths, settings) => PackRecovery(paths, settings).run(),
  );
  runApp(MualimiApp(initialBinding: binding));
}
