import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_config.dart';
import 'core/utils/router.dart';
import 'core/vm/provider_initilizers.dart';
import 'features/onboarding/splash_screen.dart';

Future<void> main() async {
  // Set environment to dev before initializing
  AppConfig.setEnvironment('dev');
  
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  runApp(CheckAroundMe());
}

// initializeApp() async {
//   await Firebase.initializeApp();
//   await setUpLocator();
// }

class CheckAroundMe extends StatelessWidget {
  const CheckAroundMe({super.key});

  void _closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: ProviderInitializer.getProviders(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _closeKeyboard();
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: MaterialApp(
            theme: AppTheme.themeData,
            debugShowCheckedModeBanner: false,
            navigatorKey: router.navigatorKey,
            home:  SplashScreen(),
          ),
        ),
      ),
    );
  }
}

