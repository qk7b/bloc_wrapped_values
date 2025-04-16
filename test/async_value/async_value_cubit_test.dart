import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:test/test.dart';

class TestAsyncValueCubit extends AsyncValueCubit<int> {}

void main() {
  group('AsyncValueCubit', () {
    late TestAsyncValueCubit cubit;

    setUp(() {
      cubit = TestAsyncValueCubit();
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitLoading emits a loading state without previous value',
      build: () => cubit,
      act: (cubit) => cubit.emitLoading(),
      expect: () => [
        AsyncValueWrapper<int>.loading(),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitSuccess emits a success state with the given value',
      build: () => cubit,
      act: (cubit) => cubit.emitSuccess(91),
      expect: () => [
        AsyncValueWrapper<int>.success(91),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitLoading emits a loading state with the previous value',
      build: () => cubit,
      act: (cubit) {
        cubit.emitSuccess(42);
        cubit.emitLoading();
      },
      expect: () => [
        AsyncValueWrapper<int>.success(42),
        AsyncValueWrapper<int>.loading(oldValue: 42),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitError emits an error state with the given error',
      build: () => cubit,
      act: (cubit) => cubit.emitError('Error!'),
      expect: () => [
        AsyncValueWrapper<int>.error(err: 'Error!'),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitError emits an error state with the given error and the previous value',
      build: () => cubit,
      act: (cubit) {
        cubit.emitSuccess(42);
        cubit.emitError('Error!');
      },
      expect: () => [
        AsyncValueWrapper<int>.success(42),
        AsyncValueWrapper<int>.error(err: 'Error!', oldValue: 42),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitGuarded does not emit loading and success states when the future completes successfully with "emitLoading" set to false',
      build: () => cubit,
      wait: const Duration(milliseconds: 20),
      act: (cubit) => cubit.emitGuarded(() async {
        await Future.delayed(const Duration(milliseconds: 10));
        return 42;
      }, emitLoading: false),
      expect: () => [
        AsyncValueWrapper<int>.success(42),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitGuarded emits loading and success states when the future completes successfully',
      build: () => cubit,
      wait: const Duration(milliseconds: 20),
      act: (cubit) => cubit.emitGuarded(() async {
        await Future.delayed(const Duration(milliseconds: 10));
        return 42;
      }),
      expect: () => [
        AsyncValueWrapper<int>.loading(),
        AsyncValueWrapper<int>.success(42),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitGuarded emits loading and error states when the future throws an error',
      build: () => cubit,
      wait: const Duration(milliseconds: 20),
      act: (cubit) => cubit.emitGuarded(() async {
        await Future.delayed(const Duration(milliseconds: 10));
        throw 'Test error';
      }),
      expect: () => [
        AsyncValueWrapper<int>.loading(),
        AsyncValueWrapper<int>.error(err: 'Test error'),
      ],
    );

    blocTest<TestAsyncValueCubit, AsyncValueWrapper<int>>(
      'emitGuarded preserves previous value in loading state',
      build: () => cubit,
      act: (cubit) async {
        cubit.emitGuarded(() async => 10);
        // Add a small delay to ensure the first operation completes
        await Future.delayed(const Duration(milliseconds: 10));
        cubit.emitGuarded(() async => 20);
      },
      expect: () => [
        AsyncValueWrapper<int>.loading(),
        AsyncValueWrapper<int>.success(10),
        AsyncValueWrapper<int>.loading(oldValue: 10),
        AsyncValueWrapper<int>.success(20),
      ],
    );
  });
}
