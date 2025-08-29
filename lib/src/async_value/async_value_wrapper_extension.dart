import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';

/// Extension methods for the [AsyncValueWrapper] class.
/// These methods are used to handle the state of a [AsyncValueWrapper]
/// and return a value based on the current state.
extension AsyncValueWrapperExtension<T> on AsyncValueWrapper<T> {
  /// Map the current [AsyncValueWrapper] to a new value using the [mapper] function.
  /// Usually used to map the current [AsyncValueWrapper] to a [Widget]
  W map<W>(
      W Function({AsyncValueStatus? status, T? value, Object? err}) mapper) {
    return mapper(status: status, value: value, err: err);
  }

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
