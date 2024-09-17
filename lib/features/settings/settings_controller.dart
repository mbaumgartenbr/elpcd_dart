import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

const defaultInstitutionCode = 'ElPCD';

class SettingsController with ChangeNotifier {
  SettingsController(this._box) {
    _institutionCode = _get<String?>('codearq') ?? defaultInstitutionCode;
    _darkMode = _get<bool?>('darkMode');
  }

  final Box<Object> _box;

  T _get<T>(String key) => _box.get(key) as T;

  String get institutionCode => _institutionCode;
  String _institutionCode = defaultInstitutionCode;

  bool? get darkMode => _darkMode;
  bool? _darkMode;

  void updateInstitutionCode(String value) {
    value = value.trim();
    if (value == institutionCode) {
      return;
    }
    _institutionCode = value.isEmpty ? defaultInstitutionCode : value;
    notifyListeners();
    _box.put('codearq', institutionCode);
  }

  void updateDarkMode(bool? value) {
    if (value == darkMode) return;
    _darkMode = value;
    notifyListeners();
    value == null ? _box.delete('darkMode') : _box.put('darkMode', value);
  }
}
