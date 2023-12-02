import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/core/constants/app_constants.dart';
import 'package:parent_app/features/core/cubits/deeplink/deeplink_state.dart';
import 'package:parent_app/features/core/enums/deeplink_enums.dart';
import 'package:parent_app/features/core/repository/auth/auth_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

class DeeplinkCubit extends Cubit<DeeplinkState> {
  final AuthRepository authRepository;

  DeeplinkCubit(
    this.authRepository,
  ) : super(
          const DeeplinkState(),
        );

  Future<void> initDeepLinks() async {
    linkStream.listen(
      (String? link) async {
        // Assume child app is authorized

        debugPrint(link);
        if (link != null && link.isNotEmpty) {
          await handleDeepLink(link);
        }
      },
      onError: (error) {},
    );
  }

  Future<void> handleDeepLink(String link) async {
    try {
      final uri = Uri.parse(link);
      final module = uri.path.toLowerCase();
      // Determine deeplink path, which module it is for
      // For this assignment, we are only interested in country module

      if (module == DeeplinkModules.login.name) {
        emit(state.copyWith(
          status: DeeplinkStateStatus.authDeeplinkRequested,
        ));
      }
    } catch (e) {
      // Out of scope of this assignment
    }
  }

  Future<bool> isUserSessionValid() async {
    try {
      return await authRepository.isSessionValid();
    } catch (e) {
      return false;
    }
  }

  Future<Uri?> generateDeeplinkUrlForCities(String query) async {
    try {
      Uri? uri;

      final isSessionValid = await isUserSessionValid();

      if (isSessionValid) {
        final encryptedToken =
            await authRepository.getEncryptedToken(LocalDatabaseKeys.authToken);
        final currentUser = await authRepository.getLocalUserDetails();

        const String scheme = DeeplinkConstants.childAppScheme;
        const String path = DeeplinkConstants.countryPath;

        final encodedQuery = Uri.encodeComponent(query);

        final Map<String, String> queryParams = {
          DeeplinkConstants.countryNameQueryKey: encodedQuery,
          DeeplinkConstants.token: encryptedToken ?? '',
          DeeplinkConstants.userUniqueIdentifier: currentUser?.userId ?? '',
        };

        uri = Uri(
          scheme: scheme,
          path: path,
          queryParameters: queryParams,
        );
      }

      return uri;
    } catch (e) {
      //
      return null;
    }
  }

  Future<Uri?> generateDeeplinkUrlPostAuthentication() async {
    try {
      Uri? uri;

      final isSessionValid = await isUserSessionValid();

      if (isSessionValid) {
        final encryptedToken =
            await authRepository.getEncryptedToken(LocalDatabaseKeys.authToken);
        final currentUser = await authRepository.getLocalUserDetails();

        const String scheme = DeeplinkConstants.childAppScheme;
        const String path = DeeplinkConstants.loginPath;

        final Map<String, String> queryParams = {
          DeeplinkConstants.token: encryptedToken ?? '',
          DeeplinkConstants.userUniqueIdentifier: currentUser?.userId ?? '',
        };

        uri = Uri(
          scheme: scheme,
          path: path,
          queryParameters: queryParams,
        );
      }

      return uri;
    } catch (e) {
      //
      return null;
    }
  }

  Future<void> navigateToChildAppForCities(String query) async {
    try {
      emit(state.copyWith(
        status: DeeplinkStateStatus.sendContentDeeplinkInitializing,
      ));
      final Uri? uri = await generateDeeplinkUrlForCities(query);

      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri);
        emit(state.copyWith(
          status: DeeplinkStateStatus.sendContentDeeplinkLaunched,
        ));
      } else {
        if (kDebugMode) {
          debugPrint(
            'Could not launch $uri',
          );
        }
      }
    } catch (e) {
      //
    }
  }

  Future<void> navigateToChildApp() async {
    try {
      emit(state.copyWith(
        status: DeeplinkStateStatus.authDeeplinkProcessing,
      ));
      final Uri? uri = await generateDeeplinkUrlPostAuthentication();

      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri);
        emit(state.copyWith(
          status: DeeplinkStateStatus.authDeeplinkLaunched,
        ));
      } else {
        if (kDebugMode) {
          debugPrint(
            'Could not launch $uri',
          );
        }
      }
    } catch (e) {
      //
    }
  }
}
