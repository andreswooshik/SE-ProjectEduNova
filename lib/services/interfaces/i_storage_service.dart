/// Interface Segregation Principle: Small, focused interface for storage
/// Dependency Inversion Principle: High-level modules depend on this abstraction
abstract class IStorageService {
  /// Save a string value
  Future<bool> saveString(String key, String value);

  /// Get a string value
  Future<String?> getString(String key);

  /// Save a list of strings
  Future<bool> saveStringList(String key, List<String> value);

  /// Get a list of strings
  Future<List<String>?> getStringList(String key);

  /// Save a boolean value
  Future<bool> saveBool(String key, bool value);

  /// Get a boolean value
  Future<bool?> getBool(String key);

  /// Remove a value
  Future<bool> remove(String key);

  /// Clear all stored data
  Future<bool> clear();

  /// Check if a key exists
  Future<bool> containsKey(String key);
}
