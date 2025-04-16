import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:test/test.dart';

// Test implementation of ErrorValueCubit
class TestErrorValueCubit extends ErrorValueCubit<int> {
  TestErrorValueCubit() : super(0);
}

void main() {
  group('ErrorValueCubit', () {
    late TestErrorValueCubit cubit;

    setUp(() {
      cubit = TestErrorValueCubit();
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<TestErrorValueCubit, ErrorValueWrapper<int>>(
      'emitValue emits a value state with the given value',
      build: () => cubit,
      act: (cubit) => cubit.emitValue(42),
      expect: () => [
        ErrorValueWrapper<int>.value(42),
      ],
    );

    blocTest<TestErrorValueCubit, ErrorValueWrapper<int>>(
      'emitError emits an error state with the given error',
      build: () => cubit,
      act: (cubit) => cubit.emitError('Error!'),
      expect: () => [
        ErrorValueWrapper<int>.error('Error!', oldValue: 0),
      ],
    );

    blocTest<TestErrorValueCubit, ErrorValueWrapper<int>>(
      'emitError emits an error state with the previous value',
      build: () => cubit,
      act: (cubit) {
        cubit.emitValue(42);
        cubit.emitError('Error!');
      },
      expect: () => [
        ErrorValueWrapper<int>.value(42),
        ErrorValueWrapper<int>.error('Error!', oldValue: 42),
      ],
    );

    group('emitGuarded', () {
      blocTest<TestErrorValueCubit, ErrorValueWrapper<int>>(
        'emitGuarded emits a value state when function succeeds',
        build: () => cubit,
        act: (cubit) => cubit.emitGuarded(() => 42),
        expect: () => [
          ErrorValueWrapper<int>.value(42),
        ],
      );

      blocTest<TestErrorValueCubit, ErrorValueWrapper<int>>(
        'emitGuarded emits an error state when function throws',
        build: () => cubit,
        act: (cubit) => cubit.emitGuarded(() => throw 'Error!'),
        expect: () => [
          ErrorValueWrapper<int>.error('Error!', oldValue: 0),
        ],
      );

      blocTest<TestErrorValueCubit, ErrorValueWrapper<int>>(
        'emitGuarded preserves the previous value when function throws',
        build: () => cubit,
        act: (cubit) {
          cubit.emitValue(42);
          cubit.emitGuarded(() => throw 'Error!');
        },
        expect: () => [
          ErrorValueWrapper<int>.value(42),
          ErrorValueWrapper<int>.error('Error!', oldValue: 42),
        ],
      );
    });
  });
}
