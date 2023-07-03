import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'domain/connection.dart';
import 'domain/sentry.dart';
import 'models/connection_model.dart';
import 'pages/config_page.dart';
import 'pages/joystick_page.dart';
// ignore: unused_import
import 'theme.dart';

void main() async {
  // ensure initialized
  WidgetsFlutterBinding.ensureInitialized();

  initSentry(() => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ConnectionModel()),
          ],
          child: const UrsaApp(),
        ),
      ));

  initConnection();
}

class UrsaApp extends StatelessWidget {
  const UrsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    // bool isDarkMode =
    //     MediaQuery.of(context).platformBrightness == Brightness.dark;

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {

      // lightDynamic = lightDynamic?.copyWith(
      //   background: lightDynamic?.
      // );

      return MaterialApp(
        title: AppLocalizations.of(context)?.title ?? 'URSA Driver Station',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          // ignore: dead_code
          colorScheme: isDarkMode ? darkDynamic : lightDynamic,
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => const JoystickPage(),
          '/config': (context) => const ConfigPage(),
        },
      );
    });
  }
}
