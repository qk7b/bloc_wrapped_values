import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:test/test.dart';

class MockStorage implements Storage {
  final Map<String, dynamic> _storage = {};

  @override
  dynamic read(String key) => _storage[key];

  @override
  Future<void> write(String key, dynamic value) async {
    _storage[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<void> close() async {}
}

class TestHydratedCubit extends HydratedAsyncValueCubit<int> {
  @override
  int Function(dynamic json) valueFromJson = (json) => (json as num).toInt();

  @override
  dynamic Function(int t) valueToJson = (t) => t;
}

void main() {
  group('HydratedAsyncValueCubit', () {
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      HydratedBloc.storage = storage;
    });

    blocTest<TestHydratedCubit, AsyncValueWrapper<int>>(
      'emitLoading emits a loading state without previous value',
      build: () => TestHydratedCubit(),
      act: (cubit) => cubit.emitLoading(),
      expect: () => [
        AsyncValueWrapper<int>.loading(),
      ],
    );

    blocTest<TestHydratedCubit, AsyncValueWrapper<int>>(
      'emitSuccess emits a success state with the given value',
      build: () => TestHydratedCubit(),
      act: (cubit) => cubit.emitSuccess(91),
      expect: () => [
        AsyncValueWrapper<int>.success(91),
      ],
      verify: (cubit) {
        final dynamic stored = storage.read('TestHydratedCubit');
        expect(stored, {
          'status': 'success',
          'value': 91,
          'err': null,
        });
      },
    );

    test('restores state from storage on initialization', () {
      final cubitStateJson = {
        'status': 'success',
        'value': 100,
        'err': null,
      };

      // Seed storage
      storage.write('TestHydratedCubit', cubitStateJson);

      final cubit = TestHydratedCubit();
      expect(cubit.state.status, AsyncValueStatus.success);
      expect(cubit.state.value, 100);
      expect(cubit.state.err, isNull);

      cubit.close();
    });

    test('restores initial state if storage is empty', () {
      final cubit = TestHydratedCubit();
      expect(cubit.state.status, AsyncValueStatus.initial);
      expect(cubit.state.value, isNull);
      expect(cubit.state.err, isNull);

      cubit.close();
    });
  });
}
