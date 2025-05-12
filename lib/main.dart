import 'package:flutter/material.dart';
import 'package:expense_tracker/expenses.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  brightness: Brightness.dark,
);
var kLightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
  brightness: Brightness.light,
);

TextTheme get kTextTheme {
  return GoogleFonts.latoTextTheme().copyWith(
    titleLarge: GoogleFonts.lato(
      fontWeight: FontWeight.bold,
      color: kColorScheme.onSecondaryContainer,
      fontSize: 20,
    ),
    labelLarge: GoogleFonts.lato(color: kColorScheme.onPrimaryContainer),
  );
}

TextTheme get kDarkTextTheme {
  return kTextTheme.copyWith(
    titleLarge: kTextTheme.titleLarge!.copyWith( color: kDarkColorScheme.onSecondaryContainer,),
    labelLarge: kTextTheme.labelLarge!.copyWith( color: kDarkColorScheme.onPrimaryContainer),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme:  ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kDarkColorScheme.onPrimaryContainer,
          foregroundColor: kDarkColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: kDarkTextTheme,
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
            foregroundColor: kColorScheme.onPrimaryContainer,
          ),
        ),
        textTheme: kTextTheme,
      ),
      themeMode: ThemeMode.system,
      home: Expenses(),
    );
  }
}
