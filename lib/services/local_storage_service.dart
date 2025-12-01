import 'package:shared_preferences/shared_preferences.dart';
import 'interfaces/i_storage_service.dart';

/// Concrete implementation of IStorageService using SharedPreferences
/// Open/Closed Principle: Can be replaced with Firebase or other storage without changing clients
class LocalStorageService implements IStorageService {
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<bool> saveString(String key, String value) async {
    await _ensureInitialized();
    return await _prefs!.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs!.getString(key);
  }

  @override
  Future<bool> saveStringList(String key, List<String> value) async {
    await _ensureInitialized();
    return await _prefs!.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    await _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  @override
  Future<bool> saveBool(String key, bool value) async {
    await _ensureInitialized();
    return await _prefs!.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    return _prefs!.getBool(key);
  }

  @override
  Future<bool> remove(String key) async {
    await _ensureInitialized();
    return await _prefs!.remove(key);
  }

  @override
  Future<bool> clear() async {
    await _ensureInitialized();
    return await _prefs!.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs!.containsKey(key);
  }
}
