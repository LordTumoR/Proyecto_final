import 'package:flutter/material.dart';

class DateManager {
  static final DateManager _instance = DateManager._internal();

  // Usar ValueNotifier para notificar cambios en la fecha
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  DateManager._internal();

  factory DateManager() {
    return _instance;
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate; // Notifica a los oyentes
    print("Fecha actualizada: ${selectedDate.value.toLocal()}");
  }
}
