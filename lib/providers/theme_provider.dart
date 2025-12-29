import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ThemeProvider extends ChangeNotifier{
ThemeMode  themeMode = ThemeMode.light;

 void toggleTeheme(bool isDark ){
   themeMode=isDark? ThemeMode.dark : ThemeMode.light;
   notifyListeners();

 }
}
final themeProvider  = StateNotifierProvider<ThemeNorifier,ThemeMode>((ref)=>ThemeNorifier());


class ThemeNorifier  extends StateNotifier<ThemeMode>{
  ThemeNorifier():super(ThemeMode.light);

  void toggleTheme(isDark){
    state = isDark? ThemeMode.dark : ThemeMode.light;
  }
}