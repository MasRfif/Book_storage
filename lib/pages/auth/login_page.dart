import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_tracker_v9/bloc/auth/auth_cubit.dart';
import 'package:book_tracker_v9/bloc/auth/auth_state.dart';
import 'package:book_tracker_v9/bloc/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late final AuthCubit authCubit;

  var showPassword = true;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen:
              (p, c) =>
                  ((p.errorMessage == '' && c.errorMessage != '') ||
                      (p.isLoggedIn == false && c.isLoggedIn == true)),
          listener: (context, state) {
            if (state.errorMessage != '') {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Gagal Login'),
                      content: Text(state.errorMessage),
                      actions: [
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            } else if (state.isLoggedIn) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Selamat Datang Kembali!",
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.onPrimary,
                  hintText: "Email",
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: showPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.onPrimary,
                  hintText: "Password",
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  suffixIcon: IconButton(
                    onPressed:
                        () => setState(() => showPassword = !showPassword),
                    icon: Icon(
                      Icons.visibility,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              SizedBox(height: 24),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          () => authCubit.login(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          theme.colorScheme.onPrimary,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child:
                          state.loading
                              ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    82,
                                    79,
                                    79,
                                  ),
                                ),
                              )
                              : Text(
                                "Login",
                                style: TextStyle(
                                  fontFamily: 'PlayfairDisplay',
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
