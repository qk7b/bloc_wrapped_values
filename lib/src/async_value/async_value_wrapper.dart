/// [AsyncValueStatus] indicates the state of the [AsyncValueWrapper].
/// It can be [AsyncValueStatus.initial], [AsyncValueStatus.loading], [AsyncValueStatus.success], or [AsyncValueStatus.error].
/// Those values are used to determine in which state the [AsyncValueWrapper] is.
enum AsyncValueStatus {
  /// The [AsyncValueWrapper] is in the initial state.
  initial,

  /// The [AsyncValueWrapper] is in the loading state.
  loading,

  /// The [AsyncValueWrapper] is in the success state.
  success,

  /// The [AsyncValueWrapper] is in the error state.
  error;

  @override
  toString() => 'AsyncValueStatus.$name';
}

/// A [AsyncValueWrapper] represents a value that is either loading, success, or error.
/// It contains a value that is of type [T] and a status that is of type [AsyncValueStatus].
/// It is used to handle the state of a value within a [Cubit] or [Bloc].
class AsyncValueWrapper<T> {
  const AsyncValueWrapper._({
    this.value,
    this.status = AsyncValueStatus.initial,
    this.err,
  });

  /// The value of the [AsyncValueWrapper].
  final T? value;

  /// The status of the [AsyncValueWrapper].
  final AsyncValueStatus status;

  /// In case the [AsyncValueWrapper] is in the [AsyncValueStatus.error] state, this field contains the error message.
  final Object? err;

  /// Creates a new [AsyncValueWrapper] with the given [value].
  /// [status] defaults to [AsyncValueStatus.initial].
  /// [err] defaults to null.
  /// if [initialValue] is provided, it will be used
  factory AsyncValueWrapper.initial({T? initialValue}) =>
      AsyncValueWrapper<T>._(
        status: AsyncValueStatus.initial,
        value: initialValue,
      );

  /// Creates a new [AsyncValueWrapper] with the given [value].
  /// [status] defaults to [AsyncValueStatus.loading].
  /// [error] defaults to null.
  /// if [oldValue] is provided, it will be used
  factory AsyncValueWrapper.loading({T? oldValue}) => AsyncValueWrapper<T>._(
        status: AsyncValueStatus.loading,
        value: oldValue,
      );

  /// Creates a new [AsyncValueWrapper] with the given [value].
  /// [status] defaults to [AsyncValueStatus.success].
  /// [err] defaults to null.
  factory AsyncValueWrapper.success(T value) => AsyncValueWrapper<T>._(
        value: value,
        status: AsyncValueStatus.success,
      );

  /// Creates a new [AsyncValueWrapper] with the given [err].
  /// [status] defaults to [AsyncValueStatus.error].
  /// [err] defaults to null.
  /// if [oldValue] is provided, it will be used
  factory AsyncValueWrapper.error({Object? err, T? oldValue}) =>
      AsyncValueWrapper<T>._(
        status: AsyncValueStatus.error,
        value: oldValue,
        err: err,
      );

  /// Hashcode and equality are used to compare two [AsyncValueWrapper] objects
  /// based on their value, status, and error.
  /// The hashcode is calculated based on the value, status, and error.
  /// The equality is based on the value, status, and error.
  /// If the value, status, and error are the same, the objects are considered equal.
  /// This is used by the [Cubit] and [Bloc] to determine if the state has changed.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncValueWrapper<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          status == other.status &&
          err == other.err;

  @override
  int get hashCode => value.hashCode ^ status.hashCode ^ err.hashCode;

  @override
  String toString() {
    return 'AsyncValueWrapper{value: $value, status: $status, err: $err}';
  }
}

/// Extension methods for the [AsyncValueWrapper] class.
/// These methods are used to handle the state of a [AsyncValueWrapper]
/// and return a value based on the current state.
extension AsyncValueWrapperWhenExtension<T> on AsyncValueWrapper<T> {
  /// Returns the result of the [when] function.
  /// based on each possible [AsyncValueStatus] of the [AsyncValueWrapper]
  W when<W>({
    required W Function() initial,
    required W Function(T? oldValue) loading,
    required W Function(T value) success,
    required W Function(Object err, T? oldValue) error,
  }) {
    return switch (status) {
      AsyncValueStatus.initial => initial(),
      AsyncValueStatus.loading => loading(value),
      AsyncValueStatus.success => success(value as T),
      AsyncValueStatus.error => error(err!, value),
    };
  }

  /// Calls [success] with the value of this [AsyncValueWrapper] if
  /// it is in the [AsyncValueStatus.success] state. Otherwise, calls [orElse].
  ///
  /// This function is similar to [when], but does not force you to
  /// handle every possible [AsyncValueStatus].
  ///
  /// The [success] function is called with the value of this
  /// [AsyncValueWrapper] if it is in the [AsyncValueStatus.success] state.
  ///
  /// The [orElse] function is called in all other cases.
  W maybeWhen<W>({
    required W Function(T value) success,
    required W Function() orElse,
  }) {
    return switch (status) {
      AsyncValueStatus.success => success(value as T),
      _ => orElse(),
    };
  }
}
