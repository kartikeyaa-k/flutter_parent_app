import 'package:equatable/equatable.dart';
import 'package:parent_app/features/core/mock_model/mock_user_model.dart';

enum AuthStateStatus {
  init,
  loading,
  failure,

  loginProcessing,
  loginSuccess,

  isAuthenticatedVerifying,
  isAuthenticatedSuccess,
  isNotAuthenticated,

  loggingOutProcessing,
  logoutSuccess,
}

class AuthState extends Equatable {
  final AuthStateStatus status;
  final bool isLoggedIn;
  final bool isSessionValid;
  final MockUserModel? user;
  final bool isLaunchAuthVerification;

  const AuthState({
    this.status = AuthStateStatus.init,
    required this.isLoggedIn,
    this.isSessionValid = false,
    this.user,
    this.isLaunchAuthVerification = false,
  });

  @override
  List<Object?> get props => [
        status,
        isLoggedIn,
        isSessionValid,
        user,
        isLaunchAuthVerification,
      ];

  AuthState copyWith({
    AuthStateStatus? status,
    bool? isLoggedIn,
    bool? isSessionValid,
    MockUserModel? user,
    bool? isLaunchAuthVerification,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isSessionValid: isSessionValid ?? this.isSessionValid,
      user: user ?? this.user,
      isLaunchAuthVerification:
          isLaunchAuthVerification ?? this.isLaunchAuthVerification,
    );
  }
}
