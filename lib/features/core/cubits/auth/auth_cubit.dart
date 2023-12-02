import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/core/cubits/auth/auth_state.dart';
import 'package:parent_app/features/core/repository/auth/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository})
      : super(const AuthState(isLoggedIn: false));

  Future<void> login(String username, String password) async {
    try {
      emit(
        state.copyWith(
          status: AuthStateStatus.loginProcessing,
        ),
      );
      // Perform login logic using authRepository
      final user = await authRepository.login(username, password);

      // Emit a new state indicating successful login
      emit(
        state.copyWith(
          status: AuthStateStatus.loginSuccess,
          isLoggedIn: true,
          isSessionValid: true,
          user: user,
        ),
      );
    } catch (e) {
      // Handle login failure (you might want to emit different states for different failure scenarios)
      emit(
        state.copyWith(
          status: AuthStateStatus.failure,
          isLoggedIn: false,
          isSessionValid: false,
        ),
      );
    }
  }

  Future<void> isUserSessionValid() async {
    try {
      emit(
        state.copyWith(
          status: AuthStateStatus.isAuthenticatedVerifying,
        ),
      );
      // Check if the user session is valid using authRepository
      final isSessionValid = await authRepository.isSessionValid();
      if (isSessionValid) {
        emit(
          state.copyWith(
            status: AuthStateStatus.isAuthenticatedSuccess,
            isLoggedIn: true,
            isSessionValid: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStateStatus.isNotAuthenticated,
            isLoggedIn: false,
            isSessionValid: false,
          ),
        );
      }
    } catch (e) {
      // Handle login failure (you might want to emit different states for different failure scenarios)
      emit(
        state.copyWith(
          status: AuthStateStatus.isNotAuthenticated,
          isLoggedIn: false,
          isSessionValid: false,
        ),
      );
    }
  }

  Future<void> logoutUser() async {
    try {
      emit(
        state.copyWith(
          status: AuthStateStatus.loggingOutProcessing,
        ),
      );
      // Check if the user session is valid using authRepository
      await authRepository.logout();

      emit(
        state.copyWith(
          status: AuthStateStatus.logoutSuccess,
          isLoggedIn: false,
          isSessionValid: false,
          isLaunchAuthVerification: false,
        ),
      );
    } catch (e) {
      // Handle login failure (you might want to emit different states for different failure scenarios)
      emit(
        state.copyWith(
          status: AuthStateStatus.failure,
          isLoggedIn: false,
          isSessionValid: false,
          isLaunchAuthVerification: false,
        ),
      );
    }
  }
}
