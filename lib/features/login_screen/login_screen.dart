import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/core/constants/app_strings.dart';
import 'package:parent_app/features/core/cubits/auth/auth_cubit.dart';
import 'package:parent_app/features/core/cubits/auth/auth_state.dart';
import 'package:parent_app/features/core/style/primary_theme.dart';
import 'package:parent_app/features/core/style/textfield_style.dart';
import 'package:parent_app/features/home_screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit _authCubit;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStateStatus.loginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  const Text(
                    'Parent App Login Screen',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(
                            color: PrimaryTheme.alternativeColor,
                            fontSize: 16,
                          ),
                          decoration: primaryTextFieldDecoration(
                            hintText: AppStrings.username,
                          ),
                          onChanged: (value) {},
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          style: const TextStyle(
                            color: PrimaryTheme.alternativeColor,
                            fontSize: 16,
                          ),
                          decoration: primaryTextFieldDecoration(
                            hintText: AppStrings.password,
                          ),
                          onChanged: (value) {},
                        ),
                      ],
                    )),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _authCubit.login('', '');
                    },
                    child: _authCubit.state.status ==
                            AuthStateStatus.loginProcessing
                        ? const CupertinoActivityIndicator()
                        : const Text('Mock Login'),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
