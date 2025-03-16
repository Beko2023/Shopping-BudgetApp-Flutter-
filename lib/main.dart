import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_cart/providers/theme_provider.dart';
import 'package:shopping_cart/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
        darkTheme: ThemeData.dark(),
        themeMode: themeMode,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('es', 'ES'), // Spanish
        ],
        debugShowCheckedModeBanner: false,
        title: 'Berks Groceries & Budget App',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 32, 81, 141),
            secondary: Color.fromARGB(255, 189, 114, 1),
            surface: Color.fromARGB(255, 253, 254, 255),
            onSurface: Color.fromARGB(255, 9, 43, 94),
            onPrimary: Colors.white,
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.roboto(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
            bodyMedium: GoogleFonts.roboto(fontSize: 16),
            bodyLarge:
                GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600),
            displaySmall: GoogleFonts.roboto(),
          ),
        ),
        home: const HomeScreen());
  }
}
