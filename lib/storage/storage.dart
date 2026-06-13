abstract interface class Storage {
  const Storage();

  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
  Future<Map<String, Object?>> readAll(Set<String> keys);
}
