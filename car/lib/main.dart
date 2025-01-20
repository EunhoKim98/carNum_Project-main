
import 'package:flutter/material.dart';
import 'package:car/theme/app_theme.dart';
import 'package:car/views/main_view.dart';

void main() {
   runApp(const CarState());
}

class CarState extends StatelessWidget {
   const CarState({super.key});

   @override
   Widget build(BuildContext context) {
      return MaterialApp(
         theme: AppTheme.lightTheme(context),
         title: 'Car State Check',
         themeMode: ThemeMode.light,
         home: const MainPage(),
      );
   }
}
