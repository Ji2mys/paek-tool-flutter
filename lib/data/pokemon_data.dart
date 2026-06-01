import '../models/pokemon.dart';

final Map<String, Nature> natures = {
  'Hardy': NeutralNature(),
  'Docile': NeutralNature(),
  'Serious': NeutralNature(),
  'Bashful': NeutralNature(),
  'Quirky': NeutralNature(),
  'Lonely': ModifyingNature(increases: 'atk', decreases: 'def'),
  'Brave': ModifyingNature(increases: 'atk', decreases: 'speed'),
  'Adamant': ModifyingNature(increases: 'atk', decreases: 'spAtk'),
  'Naughty': ModifyingNature(increases: 'atk', decreases: 'spDef'),
  'Bold': ModifyingNature(increases: 'def', decreases: 'atk'),
  'Relaxed': ModifyingNature(increases: 'def', decreases: 'speed'),
  'Impish': ModifyingNature(increases: 'def', decreases: 'spAtk'),
  'Lax': ModifyingNature(increases: 'def', decreases: 'spDef'),
  'Timid': ModifyingNature(increases: 'speed', decreases: 'atk'),
  'Hasty': ModifyingNature(increases: 'speed', decreases: 'def'),
  'Jolly': ModifyingNature(increases: 'speed', decreases: 'spAtk'),
  'Naive': ModifyingNature(increases: 'speed', decreases: 'spDef'),
  'Modest': ModifyingNature(increases: 'spAtk', decreases: 'atk'),
  'Mild': ModifyingNature(increases: 'spAtk', decreases: 'def'),
  'Quiet': ModifyingNature(increases: 'spAtk', decreases: 'speed'),
  'Rash': ModifyingNature(increases: 'spAtk', decreases: 'spDef'),
  'Calm': ModifyingNature(increases: 'spDef', decreases: 'atk'),
  'Gentle': ModifyingNature(increases: 'spDef', decreases: 'def'),
  'Sassy': ModifyingNature(increases: 'spDef', decreases: 'speed'),
  'Careful': ModifyingNature(increases: 'spDef', decreases: 'spAtk'),
};

// ---------------------------------------------------------------------------
// Cities
// ---------------------------------------------------------------------------

class City {
  final String label;
  const City({required this.label});
}

const Map<String, City> cities = {
  'palletTown': City(label: 'Pueblo Paleta'),
  'viridianCity': City(label: 'Ciudad Verde'),
  'pewterCity': City(label: 'Ciudad Plateada'),
  'ceruleanCity': City(label: 'Ciudad Celeste'),
  'saffronCity': City(label: 'Ciudad Azafrán'),
  'vermillionCity': City(label: 'Ciudad Carmín'),
  'celadonCity': City(label: 'Ciudad Azulona'),
  'fuchsiaCity': City(label: 'Ciudad Fucsia'),
  'lavenderTown': City(label: 'Pueblo Lavanda'),
  'cinnabarIsland': City(label: 'Isla Canela'),
};

class InitialPokemonData {
  final int speciesIdx;
  final double odds;
  final Region region;

  const InitialPokemonData({
    required this.speciesIdx,
    required this.odds,
    this.region = Region.kanto,
  });
}

/// Weighted Pokémon probability tables per hometown.
///
/// Each city maps Pokédex numbers (int) to probability weights (double).
/// Regional / Alolan form entries (fractional IDs such as 19.1, 27.1…)
/// are intentionally excluded and will be added in a later update.
///
/// Ported from `INITIAL_POKEMONS` in `src/app/data/pokemon.ts`.
const Map<String, List<InitialPokemonData>> initialPokemons = {
  'palletTown': [
    InitialPokemonData(speciesIdx: 118, odds: 0.17),
    InitialPokemonData(speciesIdx: 116, odds: 0.07),
    InitialPokemonData(speciesIdx: 16, odds: 0.18),
    InitialPokemonData(speciesIdx: 60, odds: 0.16),
    InitialPokemonData(speciesIdx: 19, odds: 0.12),
    InitialPokemonData(speciesIdx: 90, odds: 0.05),
    InitialPokemonData(speciesIdx: 120, odds: 0.06),
    InitialPokemonData(speciesIdx: 72, odds: 0.19),
  ],
  'viridianCity': [
    InitialPokemonData(speciesIdx: 10, odds: 0.05),
    InitialPokemonData(speciesIdx: 118, odds: 0.10),
    InitialPokemonData(speciesIdx: 56, odds: 0.04),
    InitialPokemonData(speciesIdx: 29, odds: 0.07),
    InitialPokemonData(speciesIdx: 32, odds: 0.13),
    InitialPokemonData(speciesIdx: 16, odds: 0.17),
    InitialPokemonData(speciesIdx: 60, odds: 0.11),
    InitialPokemonData(speciesIdx: 19, odds: 0.18),
    InitialPokemonData(speciesIdx: 21, odds: 0.07),
    InitialPokemonData(speciesIdx: 13, odds: 0.08),
  ],
  'pewterCity': [
    InitialPokemonData(speciesIdx: 10, odds: 0.05),
    InitialPokemonData(speciesIdx: 74, odds: 0.01),
    InitialPokemonData(speciesIdx: 39, odds: 0.06),
    InitialPokemonData(speciesIdx: 56, odds: 0.04),
    InitialPokemonData(speciesIdx: 29, odds: 0.07),
    InitialPokemonData(speciesIdx: 32, odds: 0.07),
    InitialPokemonData(speciesIdx: 46, odds: 0.01),
    InitialPokemonData(speciesIdx: 16, odds: 0.21),
    InitialPokemonData(speciesIdx: 19, odds: 0.17),
    InitialPokemonData(speciesIdx: 27, odds: 0.07),
    InitialPokemonData(speciesIdx: 21, odds: 0.13),
    InitialPokemonData(speciesIdx: 13, odds: 0.04),
    InitialPokemonData(speciesIdx: 41, odds: 0.07),
  ],
  'ceruleanCity': [
    InitialPokemonData(speciesIdx: 69, odds: 0.046),
    InitialPokemonData(speciesIdx: 10, odds: 0.042),
    InitialPokemonData(speciesIdx: 23, odds: 0.032),
    InitialPokemonData(speciesIdx: 118, odds: 0.093),
    InitialPokemonData(speciesIdx: 39, odds: 0.028),
    InitialPokemonData(speciesIdx: 98, odds: 0.028),
    InitialPokemonData(speciesIdx: 56, odds: 0.055),
    InitialPokemonData(speciesIdx: 52, odds: 0.055),
    InitialPokemonData(speciesIdx: 29, odds: 0.055),
    InitialPokemonData(speciesIdx: 32, odds: 0.056),
    InitialPokemonData(speciesIdx: 43, odds: 0.056),
    InitialPokemonData(speciesIdx: 16, odds: 0.069),
    InitialPokemonData(speciesIdx: 60, odds: 0.111),
    InitialPokemonData(speciesIdx: 54, odds: 0.056),
    InitialPokemonData(speciesIdx: 19, odds: 0.060),
    InitialPokemonData(speciesIdx: 27, odds: 0.056),
    InitialPokemonData(speciesIdx: 21, odds: 0.042),
    InitialPokemonData(speciesIdx: 48, odds: 0.032),
    InitialPokemonData(speciesIdx: 13, odds: 0.028),
  ],
  'saffronCity': [
    InitialPokemonData(speciesIdx: 69, odds: 0.088),
    InitialPokemonData(speciesIdx: 23, odds: 0.056),
    InitialPokemonData(speciesIdx: 58, odds: 0.060),
    InitialPokemonData(speciesIdx: 39, odds: 0.069),
    InitialPokemonData(speciesIdx: 56, odds: 0.125),
    InitialPokemonData(speciesIdx: 52, odds: 0.102),
    InitialPokemonData(speciesIdx: 43, odds: 0.069),
    InitialPokemonData(speciesIdx: 16, odds: 0.162),
    InitialPokemonData(speciesIdx: 54, odds: 0.111),
    InitialPokemonData(speciesIdx: 19, odds: 0.060),
    InitialPokemonData(speciesIdx: 27, odds: 0.042),
    InitialPokemonData(speciesIdx: 37, odds: 0.056),
  ],
  'vermillionCity': [
    InitialPokemonData(speciesIdx: 69, odds: 0.046),
    InitialPokemonData(speciesIdx: 50, odds: 0.083),
    InitialPokemonData(speciesIdx: 96, odds: 0.019),
    InitialPokemonData(speciesIdx: 23, odds: 0.028),
    InitialPokemonData(speciesIdx: 118, odds: 0.083),
    InitialPokemonData(speciesIdx: 116, odds: 0.028),
    InitialPokemonData(speciesIdx: 39, odds: 0.028),
    InitialPokemonData(speciesIdx: 56, odds: 0.042),
    InitialPokemonData(speciesIdx: 52, odds: 0.055),
    InitialPokemonData(speciesIdx: 43, odds: 0.055),
    InitialPokemonData(speciesIdx: 16, odds: 0.069),
    InitialPokemonData(speciesIdx: 60, odds: 0.074),
    InitialPokemonData(speciesIdx: 54, odds: 0.097),
    InitialPokemonData(speciesIdx: 19, odds: 0.056),
    InitialPokemonData(speciesIdx: 27, odds: 0.042),
    InitialPokemonData(speciesIdx: 90, odds: 0.042),
    InitialPokemonData(speciesIdx: 21, odds: 0.028),
    InitialPokemonData(speciesIdx: 120, odds: 0.042),
    InitialPokemonData(speciesIdx: 72, odds: 0.083),
  ],
  'celadonCity': [
    InitialPokemonData(speciesIdx: 69, odds: 0.088),
    InitialPokemonData(speciesIdx: 84, odds: 0.069),
    InitialPokemonData(speciesIdx: 118, odds: 0.148),
    InitialPokemonData(speciesIdx: 58, odds: 0.083),
    InitialPokemonData(speciesIdx: 39, odds: 0.056),
    InitialPokemonData(speciesIdx: 56, odds: 0.056),
    InitialPokemonData(speciesIdx: 52, odds: 0.056),
    InitialPokemonData(speciesIdx: 43, odds: 0.046),
    InitialPokemonData(speciesIdx: 16, odds: 0.046),
    InitialPokemonData(speciesIdx: 60, odds: 0.074),
    InitialPokemonData(speciesIdx: 19, odds: 0.056),
    InitialPokemonData(speciesIdx: 79, odds: 0.083),
    InitialPokemonData(speciesIdx: 21, odds: 0.056),
    InitialPokemonData(speciesIdx: 37, odds: 0.083),
  ],
  'fuchsiaCity': [
    InitialPokemonData(speciesIdx: 69, odds: 0.060),
    InitialPokemonData(speciesIdx: 84, odds: 0.056),
    InitialPokemonData(speciesIdx: 118, odds: 0.129),
    InitialPokemonData(speciesIdx: 116, odds: 0.069),
    InitialPokemonData(speciesIdx: 98, odds: 0.028),
    InitialPokemonData(speciesIdx: 43, odds: 0.069),
    InitialPokemonData(speciesIdx: 16, odds: 0.028),
    InitialPokemonData(speciesIdx: 60, odds: 0.102),
    InitialPokemonData(speciesIdx: 19, odds: 0.042),
    InitialPokemonData(speciesIdx: 90, odds: 0.125),
    InitialPokemonData(speciesIdx: 21, odds: 0.042),
    InitialPokemonData(speciesIdx: 120, odds: 0.042),
    InitialPokemonData(speciesIdx: 72, odds: 0.139),
    InitialPokemonData(speciesIdx: 48, odds: 0.069),
  ],
  'lavenderTown': [
    InitialPokemonData(speciesIdx: 69, odds: 0.037),
    InitialPokemonData(speciesIdx: 104, odds: 0.042),
    InitialPokemonData(speciesIdx: 23, odds: 0.041),
    InitialPokemonData(speciesIdx: 83, odds: 0.014),
    InitialPokemonData(speciesIdx: 92, odds: 0.042),
    InitialPokemonData(speciesIdx: 118, odds: 0.055),
    InitialPokemonData(speciesIdx: 58, odds: 0.041),
    InitialPokemonData(speciesIdx: 116, odds: 0.055),
    InitialPokemonData(speciesIdx: 39, odds: 0.028),
    InitialPokemonData(speciesIdx: 98, odds: 0.083),
    InitialPokemonData(speciesIdx: 66, odds: 0.028),
    InitialPokemonData(speciesIdx: 81, odds: 0.028),
    InitialPokemonData(speciesIdx: 56, odds: 0.032),
    InitialPokemonData(speciesIdx: 52, odds: 0.041),
    InitialPokemonData(speciesIdx: 29, odds: 0.028),
    InitialPokemonData(speciesIdx: 32, odds: 0.014),
    InitialPokemonData(speciesIdx: 43, odds: 0.042),
    InitialPokemonData(speciesIdx: 16, odds: 0.042),
    InitialPokemonData(speciesIdx: 60, odds: 0.042),
    InitialPokemonData(speciesIdx: 19, odds: 0.028),
    InitialPokemonData(speciesIdx: 27, odds: 0.042),
    InitialPokemonData(speciesIdx: 79, odds: 0.069),
    InitialPokemonData(speciesIdx: 21, odds: 0.014),
    InitialPokemonData(speciesIdx: 72, odds: 0.028),
    InitialPokemonData(speciesIdx: 48, odds: 0.042),
    InitialPokemonData(speciesIdx: 100, odds: 0.014),
    InitialPokemonData(speciesIdx: 37, odds: 0.028),
  ],
  'cinnabarIsland': [
    InitialPokemonData(speciesIdx: 118, odds: 0.093),
    InitialPokemonData(speciesIdx: 88, odds: 0.056),
    InitialPokemonData(speciesIdx: 58, odds: 0.060),
    InitialPokemonData(speciesIdx: 116, odds: 0.069),
    InitialPokemonData(speciesIdx: 109, odds: 0.083),
    InitialPokemonData(speciesIdx: 60, odds: 0.129),
    InitialPokemonData(speciesIdx: 77, odds: 0.056),
    InitialPokemonData(speciesIdx: 19, odds: 0.056),
    InitialPokemonData(speciesIdx: 90, odds: 0.097),
    InitialPokemonData(speciesIdx: 120, odds: 0.102),
    InitialPokemonData(speciesIdx: 72, odds: 0.116),
    InitialPokemonData(speciesIdx: 37, odds: 0.083),
  ],
  // Special table — non-regional starters only (probabilities normalized).
  // Regional-form entries will be added later.
  'special': [
    InitialPokemonData(speciesIdx: 1, odds: 0.102), // Bulbasaur
    InitialPokemonData(speciesIdx: 4, odds: 0.069), // Charmander
    InitialPokemonData(speciesIdx: 35, odds: 0.042), // Clefairy
    InitialPokemonData(
      speciesIdx: 104,
      odds: 0.028,
      region: Region.alola,
    ), // Cubone
    InitialPokemonData(
      speciesIdx: 50,
      odds: 0.028,
      region: Region.alola,
    ), // Diglett
    InitialPokemonData(speciesIdx: 133, odds: 0.083), // Eevee
    InitialPokemonData(
      speciesIdx: 83,
      odds: 0.028,
      region: Region.galar,
    ), // Farfetch'd
    InitialPokemonData(
      speciesIdx: 74,
      odds: 0.042,
      region: Region.alola,
    ), // Geodude
    InitialPokemonData(
      speciesIdx: 88,
      odds: 0.055,
      region: Region.alola,
    ), // Grimer
    InitialPokemonData(
      speciesIdx: 109,
      odds: 0.055,
      region: Region.galar,
    ), // Koffing
    InitialPokemonData(
      speciesIdx: 52,
      odds: 0.055,
      region: Region.alola,
    ), // Meowth
    InitialPokemonData(
      speciesIdx: 52,
      odds: 0.028,
      region: Region.galar,
    ), // Meowth
    InitialPokemonData(speciesIdx: 25, odds: 0.111), // Pikachu
    InitialPokemonData(
      speciesIdx: 77,
      odds: 0.056,
      region: Region.galar,
    ), // Ponyta
    InitialPokemonData(
      speciesIdx: 19,
      odds: 0.042,
      region: Region.alola,
    ), // Rattata
    InitialPokemonData(
      speciesIdx: 27,
      odds: 0.042,
      region: Region.alola,
    ), // Sandshrew
    InitialPokemonData(
      speciesIdx: 79,
      odds: 0.042,
      region: Region.galar,
    ), // Slowpoke
    InitialPokemonData(speciesIdx: 7, odds: 0.065), // Squirtle
    InitialPokemonData(
      speciesIdx: 37,
      odds: 0.028,
      region: Region.alola,
    ), // Vulpix
  ],
};
