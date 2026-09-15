// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get dashboard => 'Cuadro de mandos';

  @override
  String get new_space => 'Nuevo Espacio';

  @override
  String get new_bubble => 'Nueva burbuja';

  @override
  String get button_add => 'Añadir';

  @override
  String get button_remove => 'Borrar';

  @override
  String get button_update => 'Valider';

  @override
  String get field_name => 'Nombre';

  @override
  String get field_name_required => 'El nombre es obligatorio.';

  @override
  String get type_punctual => 'Ponctual';

  @override
  String get type_daily => 'Diario';

  @override
  String get type_weekly => 'Semanal';

  @override
  String get type_monthly => 'Mensual';

  @override
  String get empty_space_hint => 'Crea una nueva burbuja';

  @override
  String get empty_space_body => 'Añade tu primera burbuja y déjala flotar.';

  @override
  String get empty_space_cta => 'Nueva burbuja';
}
