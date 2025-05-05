import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_tracker_v9/bloc/theme_local_storage.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeLocalStorage themeLocalStorage;

  ThemeCubit(this.themeLocalStorage) : super(ThemeMode.system);

  Future<void> init() async {
    final storedTheme = themeLocalStorage.theme;
    emit(storedTheme);
  }

  Future<void> switchTheme(ThemeMode newTheme) async {
    await themeLocalStorage.setTheme(newTheme);
    emit(newTheme);
  }
}
