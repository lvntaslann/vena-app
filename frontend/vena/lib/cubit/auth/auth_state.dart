import '../../model/user/user.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;
  final String name;
  final String email;
  final String password;

  AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.name = '',
    this.email = '',
    this.password = '',
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    String? name,
    String? email,
    String? password,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
