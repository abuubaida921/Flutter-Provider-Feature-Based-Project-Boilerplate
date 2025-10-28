import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_provider_feature_based_project_boilerplate/theme/controllers/theme_controller.dart';
import 'package:flutter_provider_feature_based_project_boilerplate/theme/dark_theme.dart';
import 'package:flutter_provider_feature_based_project_boilerplate/theme/light_theme.dart';
import 'package:flutter_provider_feature_based_project_boilerplate/util/app_constants.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'features/auth/controllers/auth_controller.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'features/splash/screens/splash_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => di.sl<ThemeController>()),
    ChangeNotifierProvider(create: (context) => di.sl<OnBoardingController>()),
    ChangeNotifierProvider(create: (context) => di.sl<AuthController>()),
    ChangeNotifierProvider(create: (context) => di.sl<SplashController>()),
  ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            title: AppConstants.appName,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: themeController.darkTheme ? dark : light(
              primaryColor: themeController.selectedPrimaryColor,
              secondaryColor: themeController.selectedPrimaryColor,
            ),
            builder:(context,child){
              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child!);
            },
            home: SplashScreen(),
          );
        }
    );
  }
}

class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}