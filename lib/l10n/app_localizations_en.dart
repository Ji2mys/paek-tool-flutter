// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String pokemonType(String type) {
    String _temp0 = intl.Intl.selectLogic(type, {
      'bug': 'Bug',
      'dark': 'Dark',
      'dragon': 'Dragon',
      'electric': 'Electric',
      'fairy': 'Fairy',
      'fire': 'Fire',
      'fighting': 'Fighting',
      'flying': 'Flying',
      'grass': 'Grass',
      'ground': 'Ground',
      'ghost': 'Ghost',
      'ice': 'Ice',
      'normal': 'Normal',
      'poison': 'Poison',
      'psychic': 'Psychic',
      'rock': 'Rock',
      'steel': 'Steel',
      'water': 'Water',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String lvl(int level) {
    return 'Lvl. $level';
  }

  @override
  String get hp => 'HP';

  @override
  String get pp => 'PP';

  @override
  String trainerLevel(Object level) {
    return 'TL $level';
  }

  @override
  String city(String city) {
    String _temp0 = intl.Intl.selectLogic(city, {
      'palletTown': 'Pallet Town',
      'viridianCity': 'Viridian City',
      'pewterCity': 'Pewter City',
      'ceruleanCity': 'Cerulean City',
      'saffronCity': 'Saffron City',
      'vermillionCity': 'Vermillion City',
      'celadonCity': 'Celadon City',
      'fuchsiaCity': 'Fuchsia City',
      'lavenderTown': 'Lavender Town',
      'cinnabarIsland': 'Cinnabar Island',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String nature(String nature) {
    String _temp0 = intl.Intl.selectLogic(nature, {
      'hardy': 'Hardy',
      'docile': 'Docile',
      'serious': 'Serious',
      'bashful': 'Bashful',
      'quirky': 'Quirky',
      'lonely': 'Lonely',
      'brave': 'Brave',
      'adamant': 'Adamant',
      'naughty': 'Naughty',
      'bold': 'Bold',
      'relaxed': 'Relaxed',
      'impish': 'Impish',
      'lax': 'Lax',
      'timid': 'Timid',
      'hasty': 'Hasty',
      'jolly': 'Jolly',
      'naive': 'Naive',
      'modest': 'Modest',
      'mild': 'Mild',
      'quiet': 'Quiet',
      'rash': 'Rash',
      'calm': 'Calm',
      'gentle': 'Gentle',
      'sassy': 'Sassy',
      'careful': 'Careful',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String pkmnName(Object name, String region) {
    String _temp0 = intl.Intl.selectLogic(region, {
      'alola': 'Alolan $name',
      'galar': 'Galarian $name',
      'other': '$name',
    });
    return '$_temp0';
  }
}
