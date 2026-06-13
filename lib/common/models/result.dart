sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok(value);

  factory Result.error(
    Map<String, dynamic> rawJson, [
    Object? error,
    StackTrace? s,
  ]) => Error.withJson(rawJson, error, s);

  factory Result.notJson(String body, [Object? error, StackTrace? s]) {
    return Error(body, error, s);
  }

  bool get isSuccess => this is Ok<T>;
  bool get isError => this is Error<T>;

  Ok<T> get asSuccess {
    assert(isSuccess, 'This is not a success result, use isSuccess first');
    return this as Ok<T>;
  }

  T get successData => asSuccess.value;

  Error<T> get asError {
    assert(isError, 'This is not an error result, use isError first');
    return this as Error<T>;
  }

  String? get errorMsg {
    if (isSuccess) return null;
    return asError.toString();
  }
}

final class Ok<T> extends Result<T> {
  final T value;

  const Ok(this.value);
}

final class Error<T> extends Result<T> {
  final String? rawData;
  final Map<String, dynamic>? jsonData;
  final Object? error;
  final StackTrace? stackTrace;

  const Error(this.rawData, [this.error, this.stackTrace]) : jsonData = null;

  const Error.withJson(this.jsonData, [this.error, this.stackTrace])
    : rawData = null;
}
