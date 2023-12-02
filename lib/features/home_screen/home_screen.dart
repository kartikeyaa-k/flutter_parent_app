import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/core/cubits/auth/auth_cubit.dart';
import 'package:parent_app/features/core/cubits/auth/auth_state.dart';
import 'package:parent_app/features/core/cubits/deeplink/deeplink_cubit.dart';
import 'package:parent_app/features/core/cubits/deeplink/deeplink_state.dart';
import 'package:parent_app/features/core/mock_data/mock_parsed_countries.dart';
import 'package:parent_app/features/core/utils/snackbar/app_snackbar.dart';
import 'package:parent_app/features/login_screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late DeeplinkCubit _deeplinkCubit;
  late AuthCubit _authCubit;

  @override
  void initState() {
    _deeplinkCubit = BlocProvider.of<DeeplinkCubit>(context);
    _authCubit = BlocProvider.of<AuthCubit>(context);
    WidgetsBinding.instance.addObserver(this);
    if (_deeplinkCubit.state.status ==
        DeeplinkStateStatus.authDeeplinkRequested) {
      _deeplinkCubit.navigateToChildApp();
    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authCubit.isUserSessionValid();
      if (_deeplinkCubit.state.status ==
          DeeplinkStateStatus.authDeeplinkRequested) {
        _deeplinkCubit.navigateToChildApp();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Parent Home Screen',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black87,
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () {
                _authCubit.logoutUser();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout_outlined, color: Colors.red),
              ),
            ),
          ],
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          bloc: _authCubit,
          listener: (context, authState) {
            if (authState.status == AuthStateStatus.isNotAuthenticated) {
              _authCubit.logoutUser();
            } else if (authState.status == AuthStateStatus.logoutSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            }
          },
          builder: (context, authState) {
            return BlocListener<DeeplinkCubit, DeeplinkState>(
              listener: (context, deeplinkState) {
                if (deeplinkState.status ==
                    DeeplinkStateStatus.authDeeplinkRequested) {}
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  _authCubit.isUserSessionValid();
                },
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Hi, John Doe',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Please select a country',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(
                              countries[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: ElevatedButton(
                              child: const Text('Select'),
                              onPressed: () {
                                _deeplinkCubit.navigateToChildAppForCities(
                                    countries[index].name);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
