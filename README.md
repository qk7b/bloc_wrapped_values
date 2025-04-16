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
  bloc_wrapped_values: ^1.1.0
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

## Available helpers

- `AsyncValueCubit` with `AsyncValueWrapper` (`initial`, `loading`, `success`, `error`)
- `ErrorValueCubit` with `ErrorValueWrapper` (`value`, `error`)

## Contributing

Contributions are welcome! Please feel free to submit an [Issue](https://github.com/qk7b/bloc_wrapped_values/issues) or a Pull Request.

## License

See the **LICENSE** file for details.
