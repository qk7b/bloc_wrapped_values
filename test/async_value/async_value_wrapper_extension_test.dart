import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:test/test.dart';

void main() {
  group('AsyncValueWrapperWhenExtension', () {
    group('when method', () {
      test('calls initial callback when status is initial', () {
        final wrapper = AsyncValueWrapper<int>.initial();
        final result = wrapper.when(
          initial: () => 'initial',
          loading: (oldValue) => 'loading',
          success: (value) => 'success',
          error: (err, oldValue) => 'error',
        );
        expect(result, 'initial');
      });

      test('calls loading callback when status is loading', () {
        final wrapper = AsyncValueWrapper<int>.loading(oldValue: 42);
        final result = wrapper.when(
          initial: () => 'initial',
          loading: (oldValue) => 'loading $oldValue',
          success: (value) => 'success',
          error: (err, oldValue) => 'error',
        );
        expect(result, 'loading 42');
      });

      test('calls success callback when status is success', () {
        final wrapper = AsyncValueWrapper<int>.success(42);
        final result = wrapper.when(
          initial: () => 'initial',
          loading: (oldValue) => 'loading',
          success: (value) => 'success $value',
          error: (err, oldValue) => 'error',
        );
        expect(result, 'success 42');
      });

      test('calls error callback when status is error', () {
        final wrapper =
            AsyncValueWrapper<int>.error(err: 'Error', oldValue: 42);
        final result = wrapper.when(
          initial: () => 'initial',
          loading: (oldValue) => 'loading',
          success: (value) => 'success',
          error: (err, oldValue) => 'error $err $oldValue',
        );
        expect(result, 'error Error 42');
      });
    });

    group('maybeWhen method', () {
      test('calls success callback when status is success', () {
        final wrapper = AsyncValueWrapper<int>.success(42);
        final result = wrapper.maybeWhen(
          success: (value) => 'success $value',
          orElse: () => 'orElse',
        );
        expect(result, 'success 42');
      });

      test('calls orElse callback when status is not success', () {
        final wrapper = AsyncValueWrapper<int>.loading();
        final result = wrapper.maybeWhen(
          success: (value) => 'success',
          orElse: () => 'orElse',
        );
        expect(result, 'orElse');
      });
    });
  });
}
