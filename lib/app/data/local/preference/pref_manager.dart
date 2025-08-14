abstract class PrefManager<T> {
  Future<void> setString(String key, T value);
  Future<String?> getString(String key);
}
