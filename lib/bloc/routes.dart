import 'package:book_tracker_v9/pages/auth/login_page.dart';
import 'package:book_tracker_v9/pages/book/book_list_page.dart';
import 'package:book_tracker_v9/pages/book/add_book_page.dart';
import 'package:book_tracker_v9/pages/profile_page.dart';
import 'package:book_tracker_v9/pages/home_wrapper_page.dart';
import 'package:book_tracker_v9/pages/WelcomePage.dart';

class AppRoutes {
  static String get splash => "/splash";
  static String get login => "/login";
  static String get register => "/register";
  static String get home => "/home";
  static String get bookList => "/book/list";
  static String get addBook => "/book/add";
  static String get profile => "/profile";
}

final routes = {
  AppRoutes.splash: (context) => const WelcomePage(),
  AppRoutes.login: (context) => const LoginPage(),
  AppRoutes.home: (context) => const HomeWrapperPage(),
  AppRoutes.bookList: (context) => const BookListPage(),
  AppRoutes.addBook: (context) => const BookFormPage(),
  AppRoutes.profile: (context) => const ProfilePage(),
};
