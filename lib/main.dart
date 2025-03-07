import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popit/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/providers/locale_provider.dart';
import 'package:popit/providers/space_provider.dart';
import 'package:popit/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
          ChangeNotifierProvider(create: (context) => SpaceProvider()),
        ],
        child: Builder(builder: (context) {
          final provider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const Home(),
              locale: provider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
                Locale('fr'),
              ],
              title: 'Pop It',
              theme: theme());
        }));
  }
}
