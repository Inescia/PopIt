// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get new_space => 'Nouvel Espace';

  @override
  String get new_bubble => 'Nouvelle Bulle';

  @override
  String get button_add => 'Ajouter';

  @override
  String get button_remove => 'Supprimer';

  @override
  String get button_update => 'Valider';

  @override
  String get field_name => 'Nom';

  @override
  String get field_name_required => 'Le nom est obligatoire.';

  @override
  String get type_punctual => 'Ponctuelle';

  @override
  String get type_daily => 'Quotidienne';

  @override
  String get type_weekly => 'Hebdomadaire';

  @override
  String get type_monthly => 'Mensuelle';
}
