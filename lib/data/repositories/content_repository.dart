abstract interface class ContentRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
}

// Implement LocalJsonContentRepository first.
// A future RemoteJsonContentRepository can implement this same interface;
// screens should depend on providers/repositories, never on HTTP or assets.
