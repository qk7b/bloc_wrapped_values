import 'package:bloc/bloc.dart';
import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';

/// Base class for Cubit that emits a [ErrorValueWrapper]
abstract class ErrorValueCubit<T> extends Cubit<ErrorValueWrapper<T>> {
  /// Constructor
  ErrorValueCubit(T initial) : super(ErrorValueWrapper.value(initial));

  /// Emits [ErrorValueWrapper.value] with a new [value]
  void emitValue(
    T value,
  ) {
    emit(ErrorValueWrapper.value(value));
  }

  /// Emits a [ErrorValueWrapper.error] with an optional [err]
  /// if there was a value before, it will be passed as oldValue
  void emitError(
    Object err,
  ) =>
      emit(ErrorValueWrapper.error(
        err,
        oldValue: state.value,
      ));

  /// Calls [fn] and if it throws, emits a [ErrorValueWrapper.error] value with the error.
  /// Or emits a [ErrorValueWrapper.value] value with the result
  ///
  /// This is useful to execute a function and handle the result
  /// without having to manually emit the states.
  void emitGuarded(T Function() fn) {
    try {
      emitValue(fn());
    } catch (err) {
      emitError(err);
    }
  }
}
