import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorValueWrapper', () {
    group('value state', () {
      test('value state contains no error', () {
        final wrapper = ErrorValueWrapper.value(42);
        expect(wrapper.err, isNull);
      });

      test('value state contains the provided value', () {
        final wrapper = ErrorValueWrapper.value(42);
        expect(wrapper.value, 42);
      });
    });

    group('error state', () {
      test('error state contains the error', () {
        final error = Exception('Test error');
        final wrapper = ErrorValueWrapper.error(error);
        expect(wrapper.err, error);
      });

      test('error state contains null value if no old value', () {
        final error = Exception('Test error');
        final wrapper = ErrorValueWrapper.error(error);
        expect(wrapper.value, isNull);
      });

      test('error state contains old value if passed', () {
        final error = Exception('Test error');
        dynamic oldValue = 42;
        final wrapper = ErrorValueWrapper.error(error, oldValue: oldValue);
        expect(wrapper.value, oldValue);
      });
    });

    group('when method', () {
      test('when method returns value result for value state', () {
        final wrapper = ErrorValueWrapper.value(42);
        final result = wrapper.when(
          value: (value) => 'Value: $value',
          error: (err, oldValue) => 'Error: $err',
        );
        expect(result, 'Value: 42');
      });

      test('when method returns error result for error state', () {
        final error = Exception('Test error');
        final wrapper = ErrorValueWrapper.error(error);
        final result = wrapper.when(
          value: (value) => 'Value: $value',
          error: (err, oldValue) => 'Error: $err',
        );
        expect(result, 'Error: $error');
      });

      test('when method passes oldValue to error callback', () {
        final error = Exception('Test error');
        dynamic oldValue = 42;
        final wrapper = ErrorValueWrapper.error(error, oldValue: oldValue);
        final result = wrapper.when(
          value: (value) => 'Value: $value',
          error: (err, oldValue) => 'Error with old value: $oldValue',
        );
        expect(result, 'Error with old value: 42');
      });
    });

    group('toString method', () {
      test('toString returns correct representation for value state', () {
        final wrapper = ErrorValueWrapper.value(42);
        expect(wrapper.toString(), 'ErrorValueWrapper{value: 42, err: null}');
      });

      test('toString returns correct representation for error state', () {
        final error = Exception('Test error');
        final wrapper = ErrorValueWrapper.error(error);
        expect(
            wrapper.toString(), 'ErrorValueWrapper{value: null, err: $error}');
      });
    });
  });
}
