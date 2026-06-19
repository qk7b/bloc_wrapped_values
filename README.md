# Bloc Wrapped Values

![Pub Version](https://img.shields.io/pub/v/bloc_wrapped_values)

A Flutter package that provides a *clean and type-safe way* to handle (async) states in BLoC/Cubit patterns. 
Just wrap your values with loading, success, and error states to build reactive UIs with ease.

## Features

* 🔄 State Tracking: Easily track `loading`, `success`, and `error` states
* 🔒 Type Safety: Fully type-safe API for your data models
* 🧩 No dependency: Just `bloc` and dart
* 🎯 Simplified State Emission: Helper methods to `emit` different states
* 🔍 Pattern Matching: Convenient `when` and `maybeWhen` methods for UI rendering

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  bloc_wrapped_values: ^2.0.0
```

## Basic Example

```dart
class UserCubit extends AsyncValueCubit<User> {
  UserCubit() : super();
  
  Future<void> fetchUser(String id) async {
    emitLoading();
    
    try {
      final user = await userRepository.getUser(id);
      emitSuccess(user);
    } catch (error) {
      emitError(error);
    }
  }
}
```

or with an even more convenient way using `emitGuarded` method

```dart
class UserCubit extends AsyncValueCubit<User> {
  UserCubit() : super();
  
  Future<void> fetchUser(String id) async {
    emitGuarded(() {
        return userRepository.getUser(id);
    });
  }
}
```

And use it in your UI with `when`'s Pattern Matching like

```dart
BlocBuilder<UserCubit, AsyncValueWrapper<User>>(
  builder: (context, state) {
    return state.when(
        initial: () => InitialWidget(),
        loading: (oldUser) => UserLoadingWidget(oldUser: oldUser),
        success: (user) => UserWidget(user: user),
        error: (err, oldUser) => UserErrorWidget(err: err, oldUser: oldUser),
    );
  },
)
```

And if you don't want to handle all the cases, `AsyncValueWrapper` provides `when` and `maybeWhen` methods for easy use

```dart
// Handle only success state, with fallback for others
state.maybeWhen(
  success: (data) => SuccessWidget(data: data),
  orElse: () => DefaultWidget(),
);
```

## JSON Serialization

`AsyncValueWrapper` and `AsyncValueStatus` support JSON serialization and deserialization out of the box, making it easy to persist state (e.g., using `HydratedBloc` or caching layers).

### Manual Serialization

You can manually serialize and deserialize state wrappers by providing a converter function for your generic data type `T`:

```dart
// 1. Serialization (toJson)
final wrapper = AsyncValueWrapper<User>.success(User(name: 'Alice'));
final Map<String, dynamic> json = wrapper.toJson((user) => user.toJson());

// 2. Deserialization (fromJson)
final decodedWrapper = AsyncValueWrapper<User>.fromJson(
  json,
  (userJson) => User.fromJson(userJson as Map<String, dynamic>),
);
```

### Integration with `json_serializable` & `freezed`

If you are using code generation packages like `json_serializable` or `freezed`, you can define a custom `JsonConverter` to seamlessly handle serialization for generic wrapper properties:

```dart
import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';
import 'package:json_annotation/json_annotation.dart';

class UserAsyncValueConverter implements JsonConverter<AsyncValueWrapper<User>, Map<String, dynamic>> {
  const UserAsyncValueConverter();

  @override
  AsyncValueWrapper<User> fromJson(Map<String, dynamic> json) {
    return AsyncValueWrapper<User>.fromJson(
      json,
      (userJson) => User.fromJson(userJson as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson(AsyncValueWrapper<User> object) {
    return object.toJson((user) => user.toJson());
  }
}
```

Then, annotate your state classes with `@UserAsyncValueConverter()`:

#### With `json_serializable`:
```dart
@JsonSerializable()
class MyState {
  @UserAsyncValueConverter()
  final AsyncValueWrapper<User> userState;

  MyState(this.userState);

  factory MyState.fromJson(Map<String, dynamic> json) => _$MyStateFromJson(json);
  Map<String, dynamic> toJson() => _$MyStateToJson(this);
}
```

#### With `freezed`:
```dart
@freezed
abstract class MyState with _$MyState {
  const factory MyState({
    @UserAsyncValueConverter() required AsyncValueWrapper<User> userState,
  }) = _MyState;

  factory MyState.fromJson(Map<String, dynamic> json) => _$MyStateFromJson(json);
```

### State Persistence with `hydrated_bloc`

If you want your cubit state to persist and restore automatically across app restarts, extend `HydratedAsyncValueCubit` instead of `AsyncValueCubit`.

To configure it, simply implement the `valueFromJson` and `valueToJson` abstract members to specify how your generic value `T` should be serialized/deserialized:

```dart
class UserCubit extends HydratedAsyncValueCubit<User> {
  UserCubit() : super();

  @override
  User Function(dynamic json) get valueFromJson => 
      (json) => User.fromJson(json as Map<String, dynamic>);

  @override
  dynamic Function(User user) get valueToJson => 
      (user) => user.toJson();

  Future<void> fetchUser(String id) async {
    emitGuarded(() => userRepository.getUser(id));
  }
}
```

This automatically persists and restores the entire `AsyncValueWrapper<User>` (its state status, current value, and any active error) behind the scenes.

## Available helpers

- `AsyncValueCubit` with `AsyncValueWrapper` (`initial`, `loading`, `success`, `error`)
- `HydratedAsyncValueCubit` with `AsyncValueWrapper` for automatic persistence
- `ErrorValueCubit` with `ErrorValueWrapper` (`value`, `error`)

## Contributing

Contributions are welcome! Please feel free to submit an [Issue](https://github.com/qk7b/bloc_wrapped_values/issues) or a Pull Request.

## License

See the **LICENSE** file for details.
