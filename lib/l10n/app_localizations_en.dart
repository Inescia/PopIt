// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get new_space => 'New Space';

  @override
  String get new_bubble => 'New Bubble';

  @override
  String get button_add => 'Add';

  @override
  String get button_remove => 'Remove';

  @override
  String get button_update => 'Validate';

  @override
  String get field_name => 'Name';

  @override
  String get field_name_required => 'Name is required.';

  @override
  String get type_punctual => 'Punctual';

  @override
  String get type_daily => 'Daily';

  @override
  String get type_weekly => 'Weekly';

  @override
  String get type_monthly => 'Monthly';

  @override
  String get empty_space_hint => 'Create a new bubble';

  @override
  String get empty_space_body => 'Add your first bubble and let it float.';

  @override
  String get empty_space_cta => 'New bubble';
}
