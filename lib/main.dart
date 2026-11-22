import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_shikkha/features/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: IslamicShikkhaApp()));
}

class IslamicShikkhaApp extends StatelessWidget {
  const IslamicShikkhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF176B4D);
    return MaterialApp(
      title: 'Islamic Shikkha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF7F8F4),
        fontFamily: 'NotoSansBengali',
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          brightness: Brightness.dark,
        ),
        fontFamily: 'NotoSansBengali',
      ),
      home: const HomeScreen(),
    );
  }
}
