import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_tracker_v9/bloc/auth/auth_cubit.dart';
import 'package:book_tracker_v9/bloc/routes.dart';
import 'package:book_tracker_v9/bloc/theme_cubit.dart';
import 'package:book_tracker_v9/db/app_db.dart';
import 'package:book_tracker_v9/db/auth_local_storage.dart';
import 'package:book_tracker_v9/db/remote_data/auth_remote_data.dart';
import 'package:book_tracker_v9/injector.dart';
import 'package:book_tracker_v9/theme/dark_theme.dart';
import 'package:book_tracker_v9/theme/light_theme.dart';

class DatabaseCubit extends Cubit<AppDatabase> {
  DatabaseCubit() : super(AppDatabase.instance);

  @override
  Future<void> close() {
    state.close();
    return super.close();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => AuthCubit(
                getIt.get<AuthLocalStorage>(),
                getIt.get<AuthRemoteData>(),
              ),
        ),
        BlocProvider(create: (context) => ThemeCubit(getIt.get())..init()),
        BlocProvider<DatabaseCubit>(create: (context) => DatabaseCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Flutter FInal Project',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            initialRoute: AppRoutes.splash,
            routes: routes,
          );
        },
      ),
    );
  }
}
