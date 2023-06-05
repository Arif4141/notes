import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:notes/provider/animated_container_provider.dart';
import 'package:provider/provider.dart';

import 'menu/main_menu.dart';
import 'provider/theme_provider.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),
      ChangeNotifierProvider<AnimatedContainerProvider>(
        create: (_) => AnimatedContainerProvider(),
      ),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFF1f1d2b),
        ),
        themeMode: provider.themeMode,
        home: const MainMenu(),
      );
    });
  }
}
