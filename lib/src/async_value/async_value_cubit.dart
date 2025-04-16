import 'package:bloc/bloc.dart';
import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';

/// Base class for Cubit that emits a [AsyncValueWrapper]
/// This is made to make emit of the value easier in subclasses
abstract class AsyncValueCubit<T> extends Cubit<AsyncValueWrapper<T>> {
  /// Constructor
  AsyncValueCubit() : super(AsyncValueWrapper<T>.initial());

  /// Emits a [AsyncValueWrapper.loading] value
  /// if there was a value before, it will be passed as oldValue
  void emitLoading() => emit(
        AsyncValueWrapper.loading(
          oldValue: state.value,
        ),
      );

  /// Emits [AsyncValueWrapper.success] with a new [value]
  void emitSuccess(
    T value,
  ) {
    emit(AsyncValueWrapper.success(value));
  }

  /// Emits a [AsyncValueWrapper.error] with an optional [err]
  /// if there was a value before, it will be passed as oldValue
  void emitError(
    Object? err,
  ) =>
      emit(AsyncValueWrapper.error(
        err: err,
        oldValue: state.value,
      ));

  /// Calls [fn] and emits a [AsyncValueWrapper.loading] value.
  /// Then, when [fn] completes, emits a [AsyncValueWrapper.success] value with the result.
  /// If [fn] fails, emits a [AsyncValueWrapper.error] value with the error.
  ///
  /// If [emitLoading] is false, it will not emit a [AsyncValueWrapper.loading] value.
  /// This is useful if you want to emit the loading state manually.
  ///
  /// This is useful to execute a function and handle the result
  /// without having to manually emit the states.
  void emitGuarded(
    Future<T> Function() fn, {
    bool emitLoading = true,
  }) {
    if (emitLoading) {
      this.emitLoading();
    }
    fn()
        .then((value) => emitSuccess(value))
        .catchError((err) => emitError(err));
  }
}
