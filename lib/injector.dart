import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book_tracker_v9/bloc/theme_local_storage.dart';
import 'package:book_tracker_v9/db/app_db.dart';
import 'package:book_tracker_v9/db/auth_local_storage.dart';
import 'package:book_tracker_v9/db/remote_data/auth_remote_data.dart';
import 'package:book_tracker_v9/db/remote_data/network_service/network_service.dart';

final getIt = GetIt.instance;

Future<void> setupInjector() async {
  await hiveInjector();
  localStorageInjector();
  networkInjector();
  getIt.registerSingleton(AppDatabase.instance);
  final sp = await SharedPreferences.getInstance();
  getIt.registerSingleton(sp);
}

Future<void> hiveInjector() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  var box = await Hive.openBox('app');
  getIt.registerSingleton<Box>(box);
}

void localStorageInjector() {
  getIt.registerSingleton(AuthLocalStorage(getIt.get<Box>()));
  getIt.registerSingleton(ThemeLocalStorage(getIt.get<Box>()));
}

void networkInjector() {
  final networkService = NetworkService(getIt.get<AuthLocalStorage>());
  getIt.registerSingleton(networkService);
  getIt.registerSingleton<AuthRemoteData>(AuthRemoteDataImpl(networkService));
}
