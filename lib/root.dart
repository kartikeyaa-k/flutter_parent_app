import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/core/cubits/auth/auth_cubit.dart';
import 'package:parent_app/features/core/cubits/deeplink/deeplink_cubit.dart';
import 'package:parent_app/features/splash_screen/splash_screen.dart';
import 'package:parent_app/service_locator.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late DeeplinkCubit deeplinkCubit;

  @override
  void initState() {
    deeplinkCubit = locator<DeeplinkCubit>();
    deeplinkCubit.initDeepLinks();
    super.initState();
  }

  @override
  void dispose() {
    deeplinkCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => locator.get<AuthCubit>(),
        ),
        BlocProvider.value(value: deeplinkCubit),
      ],
      child: const MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
