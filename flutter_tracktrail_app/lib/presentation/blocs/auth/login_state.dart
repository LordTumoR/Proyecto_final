//No extendemos a equatable para que siempre se considere un estado distinto de otro. Simplemente para poder mostrar el
//usuario que ha hecho login al pulsar el botón
class LoginState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final bool isRegisterMode;

  const LoginState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
    this.isRegisterMode = false,
  });

  // Método copyWith
  LoginState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
    bool? isRegisterMode,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isRegisterMode: isRegisterMode ?? this.isRegisterMode,
    );
  }

  // Estados predefinidos
  factory LoginState.initial() => const LoginState();

  factory LoginState.loading() => const LoginState(isLoading: true);

  factory LoginState.success(String email) => LoginState(email: email);

  factory LoginState.failure(String errorMessage) =>
      LoginState(errorMessage: errorMessage);

  // @override
  // List<Object?> get props => [isLoading, email, errorMessage];
}
