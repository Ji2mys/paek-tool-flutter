import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:paek_game_tool_flutter/models/moves.dart';
import 'package:paek_game_tool_flutter/services/game_data_service.dart';
import 'package:paek_game_tool_flutter/services/pokemon_service.dart';

import '../data/pokemon_data.dart';

part 'pokemon.g.dart';

sealed class Nature {
  const Nature();
}

class ModifyingNature extends Nature {
  final String increases;
  final String decreases;

  const ModifyingNature({required this.increases, required this.decreases});
}

class NeutralNature extends Nature {
  const NeutralNature();
}

@JsonSerializable()
class NextLevelFormula {
  final int exp;
  final bool fivePerTen;

  const NextLevelFormula({required this.exp, this.fivePerTen = true});

  factory NextLevelFormula.fromJson(Map<String, dynamic> json) =>
      _$NextLevelFormulaFromJson(json);

  Map<String, dynamic> toJson() => _$NextLevelFormulaToJson(this);
}

@JsonSerializable()
class GrowthStage {
  final NextLevelFormula nextLevel;
  final int combat;

  const GrowthStage({required this.nextLevel, required this.combat});

  factory GrowthStage.fromJson(Map<String, dynamic> json) =>
      _$GrowthStageFromJson(json);

  Map<String, dynamic> toJson() => _$GrowthStageToJson(this);
}

class GrowthType {
  final GrowthStage stageA;
  final GrowthStage stageB;
  final GrowthStage stageC;

  const GrowthType({
    required this.stageA,
    required this.stageB,
    required this.stageC,
  });
}

@JsonSerializable()
class PokemonStats {
  int atk;
  int def;
  int spAtk;
  int spDef;
  int speed;
  int hp;
  int pp;

  PokemonStats({
    this.atk = 0,
    this.def = 0,
    this.spAtk = 0,
    this.spDef = 0,
    this.speed = 0,
    this.hp = 0,
    this.pp = 0,
  });

  factory PokemonStats.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonStatsToJson(this);

  /// Allows iterating stats by string key, mirroring `for (const key in stats)`.
  int operator [](String key) => switch (key) {
    'atk' => atk,
    'def' => def,
    'spAtk' => spAtk,
    'spDef' => spDef,
    'speed' => speed,
    'hp' => hp,
    'pp' => pp,
    _ => throw ArgumentError('Unknown stat key: $key'),
  };

  void operator []=(String key, int value) {
    switch (key) {
      case 'atk':
        atk = value;
      case 'def':
        def = value;
      case 'spAtk':
        spAtk = value;
      case 'spDef':
        spDef = value;
      case 'speed':
        speed = value;
      case 'hp':
        hp = value;
      case 'pp':
        pp = value;
      default:
        throw ArgumentError('Unknown stat key: $key');
    }
  }

  /// All stat keys in declaration order — used wherever TS iterates with `for…in`.
  static const List<String> keys = [
    'atk',
    'def',
    'spAtk',
    'spDef',
    'speed',
    'hp',
    'pp',
  ];
}

enum PokemonType {
  bug,
  dark,
  dragon,
  electric,
  fairy,
  fire,
  fighting,
  flying,
  grass,
  ground,
  ghost,
  ice,
  normal,
  poison,
  psychic,
  rock,
  steel,
  water,
}

class TypeRelation {
  final List<PokemonType> immune; // 0×
  final List<PokemonType> halfDamage; // 0.5×
  final List<PokemonType> doubleDamage; // 2×

  const TypeRelation({
    required this.immune,
    required this.halfDamage,
    required this.doubleDamage,
  });
}

@JsonSerializable()
class SpeciesMoves {
  final List<int>? evolution;
  final List<int>? learning;
  final Map<int, List<int>> level;

  const SpeciesMoves({
    required this.evolution,
    required this.learning,
    required this.level,
  });

  factory SpeciesMoves.fromJson(Map<String, dynamic> json) =>
      _$SpeciesMovesFromJson(json);

  Map<String, dynamic> toJson() => _$SpeciesMovesToJson(this);
}

@JsonSerializable()
class EvolutionData {
  final int to;
  final EvolutionRequirement requires;

  const EvolutionData({required this.to, required this.requires});

  factory EvolutionData.fromJson(Map<String, dynamic> json) =>
      _$EvolutionDataFromJson(json);

  Map<String, dynamic> toJson() => _$EvolutionDataToJson(this);
}

@JsonSerializable()
class EvolutionRequirement {
  final int? level;
  final int? friendship;
  final EvolutionStone? stone;
  final int? criticalHits;

  const EvolutionRequirement({
    this.level,
    this.friendship,
    this.stone,
    this.criticalHits,
  });

  factory EvolutionRequirement.fromJson(Map<String, dynamic> json) =>
      _$EvolutionRequirementFromJson(json);

  Map<String, dynamic> toJson() => _$EvolutionRequirementToJson(this);
}

enum EvolutionStone { water, fire, ice, leaf, moon, thunder }

enum Region { alola, galar, kanto }

@JsonSerializable()
class PokemonSpecies {
  @JsonKey(name: '_id')
  final int id;
  final String name;
  final int iconIdx;
  final int stage;
  final PokemonStats baseStats;
  final NextLevelFormula nextLevel;
  final int combatExp;
  final SpeciesMoves moves;
  final List<PokemonType> types; // 1 or 2 elements
  final Map<String, String> pointImprovement;
  final List<EvolutionData>? evolutions;
  final int? prevEvolution;
  final Map<Region, Map<String, dynamic>>? regionalForms;

  const PokemonSpecies({
    required this.id,
    required this.name,
    required this.iconIdx,
    required this.stage,
    required this.baseStats,
    required this.nextLevel,
    required this.combatExp,
    required this.moves,
    required this.types,
    required this.pointImprovement,
    this.evolutions,
    this.prevEvolution,
    this.regionalForms,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpeciesFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonSpeciesToJson(this);
}

class PokemonMoves {
  final List<Move> level;
  final List<Move> learned;

  PokemonMoves({this.level = const [], this.learned = const []});

  List<Move> get allMoves => [...level, ...learned];
}

@JsonSerializable()
class DbPokemon {
  final String id;
  final int species;
  final Region region;
  final String nature;
  final int level;
  final int experience;
  final String nickname;
  final int affectionPoints;
  final int currentHp;
  final int currentPp;
  final int maxHpBonus;
  final int maxPpBonus;
  final List<int> learnedMoves;

  const DbPokemon({
    required this.id,
    required this.species,
    required this.region,
    required this.nature,
    required this.level,
    required this.experience,
    required this.nickname,
    required this.affectionPoints,
    required this.currentHp,
    required this.currentPp,
    required this.maxHpBonus,
    required this.maxPpBonus,
    required this.learnedMoves,
  });

  factory DbPokemon.fromJson(Map<String, dynamic> json) =>
      _$DbPokemonFromJson(json);

  Map<String, dynamic> toJson() => _$DbPokemonToJson(this);
}

class PokemonIndividual {
  String id;
  int speciesIdx;
  PokemonSpecies species;
  Region region;

  PokemonStats levelStats;
  int currentHp;
  int currentPp;

  String natureName;
  Nature nature;

  int level;
  int experience;
  String nickname;
  int affectionPoints;

  PokemonMoves moves;

  PokemonIndividual({
    required this.id,
    required this.speciesIdx,
    required this.species,
    required this.region,
    required this.levelStats,
    required this.currentHp,
    required this.currentPp,
    required this.natureName,
    required this.nature,
    required this.level,
    required this.experience,
    required this.nickname,
    required this.affectionPoints,
    required this.moves,
  });

  int get iconIdx {
    if (region == Region.kanto) return species.iconIdx;

    final form = species.regionalForms![region];
    if (form != null) return form['iconIdx'];
    return species.iconIdx;
  }

  factory PokemonIndividual.fromDbPokemon(DbPokemon dbPokemon) {
    final species = PokemonService.getPokemonSpecies(
      dbPokemon.species,
      dbPokemon.region,
    );

    final instance = PokemonIndividual(
      id: dbPokemon.id,
      speciesIdx: dbPokemon.species,
      species: species,
      region: dbPokemon.region,
      currentHp: dbPokemon.currentHp,
      currentPp: dbPokemon.currentPp,
      natureName: dbPokemon.nature,
      nature: natures[dbPokemon.nature] ?? NeutralNature(),
      level: dbPokemon.level,
      experience: dbPokemon.experience,
      nickname: dbPokemon.nickname,
      affectionPoints: dbPokemon.affectionPoints,
      levelStats: PokemonStats(
        atk: 0,
        def: 0,
        spAtk: 0,
        spDef: 0,
        speed: 0,
        hp: 0,
        pp: 0,
      ),
      moves: PokemonMoves(
        learned: dbPokemon.learnedMoves.map((e) {
          final moveData = GameDataService.moves.firstWhere((m) => m.id == e);
          return moveData;
        }).toList(),
      ),
    );

    instance.updateStatsAndMoves(dbPokemon.maxHpBonus, dbPokemon.maxPpBonus);

    instance.currentHp = dbPokemon.currentHp > instance.totalStats.hp
        ? instance.totalStats.hp
        : dbPokemon.currentHp;
    instance.currentPp = dbPokemon.currentPp > instance.totalStats.pp
        ? instance.totalStats.pp
        : dbPokemon.currentPp;

    return instance;
  }

  // ---- Computed properties --------------------------------------------------

  PokemonStats get totalStats => PokemonStats(
    atk: species.baseStats.atk + levelStats.atk,
    def: species.baseStats.def + levelStats.def,
    spAtk: species.baseStats.spAtk + levelStats.spAtk,
    spDef: species.baseStats.spDef + levelStats.spDef,
    speed: species.baseStats.speed + levelStats.speed,
    hp: species.baseStats.hp + levelStats.hp,
    pp: species.baseStats.pp + levelStats.pp,
  );

  int get friendshipPoints => (affectionPoints / 10).floor();

  // ---- Static factories -----------------------------------------------------

  factory PokemonIndividual.createInitial(
    int speciesIdx,
    String nickname,
    Region region,
  ) {
    final natureNames = natures.keys.toList();
    final randomIdx = Random().nextInt(natureNames.length);
    final instance = PokemonIndividual.fromDbPokemon(
      DbPokemon(
        id:
            '${nickname.isNotEmpty ? nickname : speciesIdx}-'
            '${DateTime.now().millisecondsSinceEpoch}',
        species: speciesIdx,
        region: region,
        nature: natureNames[randomIdx],
        level: 5,
        experience: 0,
        nickname: nickname.trim(),
        affectionPoints: 10,
        currentHp: 10,
        currentPp: 10,
        maxHpBonus: 10,
        maxPpBonus: 10,
        learnedMoves: [],
      ),
    );

    return instance;
  }

  // ---- Instance methods -----------------------------------------------------

  void updateStatsAndMoves(int? maxHpBonus, int? maxPpBonus) {
    for (final key in PokemonStats.keys) {
      if (key == 'hp' || key == 'pp') {
        final optionsValue = key == 'hp' ? maxHpBonus : maxPpBonus;
        final newValue = optionsValue ?? levelStats[key];

        levelStats[key] = newValue;
        continue;
      }

      levelStats[key] = 5 * level;

      final nat = nature;
      if (nat is NeutralNature) continue;
      if (nat is ModifyingNature) {
        if (nat.increases == key) {
          levelStats[key] = 7 * level;
        } else if (nat.decreases == key) {
          levelStats[key] = 3 * level;
        }
      }
    }

    final List<Move> levelMoves = [];

    for (final entry in species.moves.level.entries) {
      if (entry.key <= level) {
        final movesData = GameDataService.moves.where(
          (m) => entry.value.contains(m.id),
        );
        levelMoves.addAll(movesData);
      }
    }
  }

  int calculateNextLevel() {
    final nextLevel = species.nextLevel;
    if (nextLevel.fivePerTen) {
      final levelTens = (level / 10).floor();
      return nextLevel.exp * (level + 1) + 5 * levelTens;
    } else {
      return nextLevel.exp * level;
    }
  }

  void levelUp() {
    for (final key in PokemonStats.keys) {
      if (key == 'hp' || key == 'pp') continue;

      int levelUpBonus = 5;
      final nat = nature;
      if (nat is ModifyingNature) {
        if (nat.increases == key) {
          levelUpBonus = 7;
        } else if (nat.decreases == key) {
          levelUpBonus = 3;
        }
      }

      levelStats[key] = levelStats[key] + levelUpBonus;
    }
  }

  DbPokemon toDbPokemon() => DbPokemon(
    id: id,
    level: level,
    experience: experience,
    nickname: nickname,
    species: speciesIdx,
    region: region,
    nature: natureName,
    affectionPoints: affectionPoints,
    currentHp: currentHp,
    currentPp: currentPp,
    maxHpBonus: levelStats.hp,
    maxPpBonus: levelStats.pp,
    learnedMoves: moves.learned.map((m) => m.id).toList(),
  );
}
