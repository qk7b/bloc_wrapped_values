import 'package:bloc_wrapped_values/bloc_wrapped_values.dart';

// Step 1: Define a data model
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

// Step 2: Create a repository to simulate API calls
class UserRepository {
  // Simulate network delay
  Future<User> getUser(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate error occasionally
    if (id == 'error') {
      throw Exception('Failed to load user');
    }

    // Return mock data
    return User(
      id: id,
      name: 'John Doe',
      email: 'john.doe@example.com',
    );
  }
}

// Step 3: Create a Cubit using AsyncValueCubit
class UserCubit extends AsyncValueCubit<User> {
  final UserRepository repository;

  UserCubit({required this.repository}) : super();

  // Method 1: Manual state management
  Future<void> fetchUserManually(String id) async {
    emitLoading();

    try {
      final user = await repository.getUser(id);
      emitSuccess(user);
    } catch (error) {
      emitError(error);
    }
  }

  // Method 2: Using emitGuarded for simplified state management
  Future<void> fetchUser(String id) async {
    emitGuarded(() => repository.getUser(id));
  }
}

// Example usage in a console app
void main() async {
  // Create an instance of the repository and cubit
  final repository = UserRepository();
  final userCubit = UserCubit(repository: repository);

  // Subscribe to state changes
  userCubit.stream.listen((state) {
    print('State updated: ${_formatState(state)}');
  });

  // Example 1: Successful fetch
  print('Fetching user with ID: 123');
  await userCubit.fetchUser('123');
  await Future.delayed(Duration(milliseconds: 100)); // Wait for state to update

  // Example 2: Error case
  print('\nFetching user with ID: error (will cause an error)');
  await userCubit.fetchUser('error');
  await Future.delayed(Duration(milliseconds: 100)); // Wait for state to update

  // Example 3: Using manual state management
  print('\nFetching user with manual state management');
  await userCubit.fetchUserManually('456');

  // Example 4: Demonstrating state pattern matching
  print('\nDemonstrating pattern matching with when()');
  final result = userCubit.state.when(
    initial: () => 'Initial state',
    loading: (oldUser) =>
        'Loading${oldUser != null ? " (previous: ${oldUser.name})" : ""}',
    success: (user) => 'Success: ${user.name}',
    error: (error, oldUser) =>
        'Error: $error${oldUser != null ? " (previous: ${oldUser.name})" : ""}',
  );
  print('Pattern matching result: $result');

  // Clean up
  await userCubit.close();
}

// Helper function to format state for printing
String _formatState(AsyncValueWrapper<User> state) {
  return state.when(
    initial: () => 'Initial state',
    loading: (oldUser) =>
        'Loading${oldUser != null ? " (previous: ${oldUser.name})" : ""}',
    success: (user) => 'Success: $user',
    error: (error, oldUser) =>
        'Error: $error${oldUser != null ? " (previous: ${oldUser.name})" : ""}',
  );
}
