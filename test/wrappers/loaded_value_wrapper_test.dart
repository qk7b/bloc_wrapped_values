import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:test/test.dart';

void main() {
  group('LoadedValueWrapper', () {
    group('initial state', () {
      test('initial state contains initial status', () {
        final wrapper = AsyncValueWrapper.initial();
        expect(wrapper.status, AsyncValueStatus.initial);
      });

      test('initial state contains null value if no given value', () {
        final wrapper = AsyncValueWrapper.initial();
        expect(wrapper.value, isNull);
      });

      test('initial state contains initial value if passed', () {
        dynamic initialValue = 42;
        final wrapper = AsyncValueWrapper.initial(initialValue: initialValue);
        expect(wrapper.value, initialValue);
      });

      test('initial state contains null error', () {
        final wrapper = AsyncValueWrapper.initial();
        expect(wrapper.err, isNull);
      });
    });

    group('loading state', () {
      test('loading state contains loading status', () {
        final wrapper = AsyncValueWrapper.loading();
        expect(wrapper.status, AsyncValueStatus.loading);
      });

      test('loading state contains null value if no old value', () {
        final wrapper = AsyncValueWrapper.loading();
        expect(wrapper.value, isNull);
      });

      test('loading state contains old value if passed', () {
        dynamic oldValue = 42;
        final wrapper = AsyncValueWrapper.loading(oldValue: oldValue);
        expect(wrapper.value, oldValue);
      });

      test('loading state contains null error', () {
        final wrapper = AsyncValueWrapper.loading();
        expect(wrapper.err, isNull);
      });
    });

    group('success state', () {
      test('success state contains success status', () {
        final wrapper = AsyncValueWrapper.success(42);
        expect(wrapper.status, AsyncValueStatus.success);
      });

      test('success state contains value', () {
        final wrapper = AsyncValueWrapper.success(42);
        expect(wrapper.value, 42);
      });

      test('success state contains null error', () {
        final wrapper = AsyncValueWrapper.success(42);
        expect(wrapper.err, isNull);
      });
    });

    group('error state', () {
      test('error state contains error status', () {
        final wrapper = AsyncValueWrapper.error();
        expect(wrapper.status, AsyncValueStatus.error);
      });

      test('error state contains error if given', () {
        final err = Error();
        final wrapper = AsyncValueWrapper.error(err: err);
        expect(wrapper.err, err);
      });

      test('error state contains null value', () {
        final wrapper = AsyncValueWrapper.error();
        expect(wrapper.value, isNull);
      });

      test('error state contains old value if passed', () {
        dynamic oldValue = 42;
        final wrapper = AsyncValueWrapper.error(oldValue: oldValue);
        expect(wrapper.value, oldValue);
      });
    });
  });
}
