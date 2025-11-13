import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'core/utils/router.dart';
import 'core/vm/provider_initilizers.dart';
import 'features/onboarding/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//  await initializeApp();
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
            theme: ThemeData(
                fontFamily: "urbanist"
            ),
            debugShowCheckedModeBanner: false,
            navigatorKey: router.navigatorKey,
            home:  SplashScreen(),
          ),
        ),
      ),
    );
  }
}
