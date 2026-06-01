// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String pokemonType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'bug': 'Bicho',
      'dark': 'Siniestro',
      'dragon': 'Dragón',
      'electric': 'Eléctrico',
      'fairy': 'Hada',
      'fire': 'Fuego',
      'fighting': 'Lucha',
      'flying': 'Volador',
      'grass': 'Planta',
      'ground': 'Tierra',
      'ghost': 'Fantasma',
      'ice': 'Hielo',
      'normal': 'Normal',
      'poison': 'Veneno',
      'psychic': 'Psíquico',
      'rock': 'Roca',
      'steel': 'Acero',
      'water': 'Agua',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String lvl(int level) {
    return 'Nvl. $level';
  }

  @override
  String get hp => 'PS';

  @override
  String get pp => 'PP';

  @override
  String trainerLevel(Object level) {
    return 'NE $level';
  }

  @override
  String city(String city) {
    String _temp0 = intl.Intl.selectLogic(city, {
      'palletTown': 'Pueblo Paleta',
      'viridianCity': 'Ciudad Verde',
      'pewterCity': 'Ciudad Plateada',
      'ceruleanCity': 'Ciudad Celeste',
      'saffronCity': 'Ciudad Azafrán',
      'vermillionCity': 'Ciudad Carmín',
      'celadonCity': 'Ciudad Azulona',
      'fuchsiaCity': 'Ciudad Fucsia',
      'lavenderTown': 'Pueblo Lavanda',
      'cinnabarIsland': 'Isla Canela',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String nature(String nature) {
    String _temp0 = intl.Intl.selectLogic(nature, {
      'hardy': 'Fuerte',
      'docile': 'Dócil',
      'serious': 'Seria',
      'bashful': 'Tímida',
      'quirky': 'Rara',
      'lonely': 'Huraña',
      'bold': 'Osada',
      'adamant': 'Firme',
      'naughty': 'Pícara',
      'brave': 'Audaz',
      'relaxed': 'Plácida',
      'impish': 'Agitada',
      'lax': 'Floja',
      'timid': 'Miedosa',
      'hasty': 'Activa',
      'jolly': 'Alegre',
      'naive': 'Ingenua',
      'modest': 'Modesta',
      'mild': 'Afable',
      'quiet': 'Mansa',
      'rash': 'Alocada',
      'calm': 'Serena',
      'gentle': 'Amable',
      'sassy': 'Grosera',
      'careful': 'Cauta',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String pkmnName(Object name, String region) {
    String _temp0 = intl.Intl.selectLogic(region, {
      'alola': '$name de Alola',
      'galar': '$name de Galar',
      'other': '$name',
    });
    return '$_temp0';
  }
}
