import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:screen_me/dashboard.dart';
import 'package:window_manager/window_manager.dart';

import 'api/common.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS)) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow(
        const WindowOptions(size: Size(540, 350)), () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  await Configs.loadFromLocal();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ScreenMe',
        theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
        home: const DashboardView());
  }
}
