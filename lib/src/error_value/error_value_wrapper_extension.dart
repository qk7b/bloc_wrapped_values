import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';

/// Extension methods for the [ErrorValueWrapper] class.
/// These methods are used to handle the state of a [ErrorValueWrapper]
/// and return a value based on the current state.
extension ErrorValueWrapperWhenExtension<T> on ErrorValueWrapper<T> {
  /// Map the current [ErrorValueWrapper] to a new value using the [mapper] function.
  /// Usually used to map the current [ErrorValueWrapper] to a [Widget]
  W map<W>(W Function({T? value, Object? err}) mapper) {
    return mapper(value: value, err: err);
  }

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
