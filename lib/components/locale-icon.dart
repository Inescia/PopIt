import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:popit/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LocaleIcon extends StatelessWidget {
  const LocaleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    void setLocale() {
      String nextLocale;
      switch (locale.toString()) {
        case 'fr':
          nextLocale = 'en';
          break;
        case 'en':
          nextLocale = 'es';
          break;
        default:
          nextLocale = 'fr';
          break;
      }
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      provider.setLocale(Locale(nextLocale));
    }

    return IconButton(
        iconSize: 22,
        padding: const EdgeInsets.all(10),
        icon: Image.asset('assets/${locale.toString()}.png'),
        onPressed: () => setLocale());
  }
}
