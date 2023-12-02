import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:parent_app/features/core/cubits/auth/auth_cubit.dart';
import 'package:parent_app/features/core/cubits/deeplink/deeplink_cubit.dart';
import 'package:parent_app/features/core/repository/auth/auth_repository.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  locator.registerSingleton<AuthRepository>(
      AuthRepository(locator<FlutterSecureStorage>()));

  locator.registerSingleton<AuthCubit>(
      AuthCubit(authRepository: locator<AuthRepository>()));

  locator.registerSingleton<DeeplinkCubit>(
      DeeplinkCubit(locator<AuthRepository>()));
}
