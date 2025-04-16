/// A [ErrorValueWrapper] represents a value that is either success, or error.
/// It contains a value that is of type in case of success [T]
/// or an Error in case of failure.
/// It is used to handle the state of a value within a [Cubit] or [Bloc].
class ErrorValueWrapper<T> {
  const ErrorValueWrapper._({
    this.value,
    this.err,
  });

  /// The value of the [ErrorValueWrapper] if success
  final T? value;

  /// In case the [ErrorValueWrapper] is failed
  final Object? err;

  /// Creates a new [ErrorValueWrapper] with the given [value].
  /// [err] defaults to null.
  factory ErrorValueWrapper.value(T value) => ErrorValueWrapper<T>._(
        value: value,
      );

  /// Creates a new [ErrorValueWrapper] with the given [err].
  /// [err] defaults to null.
  /// if [oldValue] is provided, it will be used
  factory ErrorValueWrapper.error(Object? err, {T? oldValue}) =>
      ErrorValueWrapper<T>._(
        value: oldValue,
        err: err,
      );

  /// Hashcode and equality are used to compare two [ErrorValueWrapper] objects
  /// based on their value, and error.
  /// The hashcode is calculated based on the value, status, and error.
  /// The equality is based on the value, status, and error.
  /// If the value, status, and error are the same, the objects are considered equal.
  /// This is used by the [Cubit] and [Bloc] to determine if the state has changed.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorValueWrapper<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          err == other.err;

  @override
  int get hashCode => value.hashCode ^ err.hashCode;

  @override
  String toString() {
    return 'ErrorValueWrapper{value: $value, err: $err}';
  }
}

/// Extension methods for the [ErrorValueWrapper] class.
/// These methods are used to handle the state of a [ErrorValueWrapper]
/// and return a value based on the current state.
extension ErrorValueWrapperWhenExtension<T> on ErrorValueWrapper<T> {
  /// Returns the result of the [when] function.
  /// based on each possible type of the [ErrorValueWrapper]
  W when<W>({
    required W Function(T value) value,
    required W Function(Object err, T? oldValue) error,
  }) {
    if (err != null) {
      return error(err!, this.value);
    } else {
      return value(this.value as T);
    }
  }
}
