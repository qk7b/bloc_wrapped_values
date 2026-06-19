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

    group('Json serialization', () {
      group('AsyncValueStatus', () {
        test('toJson returns correct identifier string', () {
          expect(AsyncValueStatus.initial.toJson(), 'initial');
          expect(AsyncValueStatus.loading.toJson(), 'loading');
          expect(AsyncValueStatus.success.toJson(), 'success');
          expect(AsyncValueStatus.error.toJson(), 'error');
        });

        test('fromJson parses string case-insensitively', () {
          expect(AsyncValueStatus.fromJson('initial'), AsyncValueStatus.initial);
          expect(AsyncValueStatus.fromJson('INITIAL'), AsyncValueStatus.initial);
          expect(AsyncValueStatus.fromJson('loading'), AsyncValueStatus.loading);
          expect(AsyncValueStatus.fromJson('LoAdInG'), AsyncValueStatus.loading);
          expect(AsyncValueStatus.fromJson('success'), AsyncValueStatus.success);
          expect(AsyncValueStatus.fromJson('SUCCESS'), AsyncValueStatus.success);
          expect(AsyncValueStatus.fromJson('error'), AsyncValueStatus.error);
          expect(AsyncValueStatus.fromJson('ERROR'), AsyncValueStatus.error);
        });

        test('fromJson falls back to initial for unknown status', () {
          expect(AsyncValueStatus.fromJson('unknown'), AsyncValueStatus.initial);
          expect(AsyncValueStatus.fromJson(''), AsyncValueStatus.initial);
        });
      });

      group('AsyncValueWrapper', () {
        test('toJson encodes initial state correctly', () {
          final wrapper = AsyncValueWrapper<int?>.initial();
          final json = wrapper.toJson((val) => val);
          expect(json, {
            'status': 'initial',
            'value': null,
            'err': null,
          });
        });

        test('toJson encodes initial state with value correctly', () {
          final wrapper = AsyncValueWrapper<int>.initial(initialValue: 42);
          final json = wrapper.toJson((val) => val);
          expect(json, {
            'status': 'initial',
            'value': 42,
            'err': null,
          });
        });

        test('toJson encodes loading state correctly', () {
          final wrapper = AsyncValueWrapper<int>.loading(oldValue: 100);
          final json = wrapper.toJson((val) => val);
          expect(json, {
            'status': 'loading',
            'value': 100,
            'err': null,
          });
        });

        test('toJson encodes success state correctly', () {
          final wrapper = AsyncValueWrapper<String>.success('hello');
          final json = wrapper.toJson((val) => val.toUpperCase());
          expect(json, {
            'status': 'success',
            'value': 'HELLO',
            'err': null,
          });
        });

        test('toJson encodes error state correctly', () {
          final wrapper = AsyncValueWrapper<int>.error(err: 'Something went wrong', oldValue: 5);
          final json = wrapper.toJson((val) => val);
          expect(json, {
            'status': 'error',
            'value': 5,
            'err': 'Something went wrong',
          });
        });

        test('fromJson decodes initial state correctly', () {
          final json = {
            'status': 'initial',
            'value': null,
            'err': null,
          };
          final wrapper = AsyncValueWrapper<int?>.fromJson(
            json,
            (val) => val as int?,
          );
          expect(wrapper.status, AsyncValueStatus.initial);
          expect(wrapper.value, isNull);
          expect(wrapper.err, isNull);
        });

        test('fromJson decodes success state correctly', () {
          final json = {
            'status': 'success',
            'value': 42,
            'err': null,
          };
          final wrapper = AsyncValueWrapper<int>.fromJson(
            json,
            (val) => (val as num).toInt(),
          );
          expect(wrapper.status, AsyncValueStatus.success);
          expect(wrapper.value, 42);
          expect(wrapper.err, isNull);
        });

        test('fromJson decodes error state correctly', () {
          final json = {
            'status': 'error',
            'value': 10,
            'err': 'an error occurred',
          };
          final wrapper = AsyncValueWrapper<int>.fromJson(
            json,
            (val) => (val as num).toInt(),
          );
          expect(wrapper.status, AsyncValueStatus.error);
          expect(wrapper.value, 10);
          expect(wrapper.err, 'an error occurred');
        });

        test('round trip serialization/deserialization', () {
          final original = AsyncValueWrapper<int>.success(99);
          final json = original.toJson((val) => val);
          final deserialized = AsyncValueWrapper<int>.fromJson(
            json,
            (val) => (val as num).toInt(),
          );
          expect(deserialized, original);
        });
      });
    });
  });
}
