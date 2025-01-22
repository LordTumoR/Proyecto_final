import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_event.dart';
import 'package:flutter_tracktrail_app/presentation/blocs/language/language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('es'))) {
    _loadInitialLocale().then((locale) {
      add(ChangeLanguageEvent(locale));
    });

    on<ChangeLanguageEvent>((event, emit) async {
      emit(LanguageState(event.locale));
      await _saveLocaleToPreferences(event.locale);
    });
  }

  Future<Locale> _loadInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'es';
    return Locale(localeCode);
  }

  Future<void> _saveLocaleToPreferences(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}
