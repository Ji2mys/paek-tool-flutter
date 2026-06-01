// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextLevelFormula _$NextLevelFormulaFromJson(Map<String, dynamic> json) =>
    NextLevelFormula(
      exp: (json['exp'] as num).toInt(),
      fivePerTen: json['fivePerTen'] as bool? ?? true,
    );

Map<String, dynamic> _$NextLevelFormulaToJson(NextLevelFormula instance) =>
    <String, dynamic>{'exp': instance.exp, 'fivePerTen': instance.fivePerTen};

GrowthStage _$GrowthStageFromJson(Map<String, dynamic> json) => GrowthStage(
  nextLevel: NextLevelFormula.fromJson(
    json['nextLevel'] as Map<String, dynamic>,
  ),
  combat: (json['combat'] as num).toInt(),
);

Map<String, dynamic> _$GrowthStageToJson(GrowthStage instance) =>
    <String, dynamic>{
      'nextLevel': instance.nextLevel,
      'combat': instance.combat,
    };

PokemonStats _$PokemonStatsFromJson(Map<String, dynamic> json) => PokemonStats(
  atk: (json['atk'] as num?)?.toInt() ?? 0,
  def: (json['def'] as num?)?.toInt() ?? 0,
  spAtk: (json['spAtk'] as num?)?.toInt() ?? 0,
  spDef: (json['spDef'] as num?)?.toInt() ?? 0,
  speed: (json['speed'] as num?)?.toInt() ?? 0,
  hp: (json['hp'] as num?)?.toInt() ?? 0,
  pp: (json['pp'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PokemonStatsToJson(PokemonStats instance) =>
    <String, dynamic>{
      'atk': instance.atk,
      'def': instance.def,
      'spAtk': instance.spAtk,
      'spDef': instance.spDef,
      'speed': instance.speed,
      'hp': instance.hp,
      'pp': instance.pp,
    };

SpeciesMoves _$SpeciesMovesFromJson(Map<String, dynamic> json) => SpeciesMoves(
  evolution: (json['evolution'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  learning: (json['learning'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  level: (json['level'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      int.parse(k),
      (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
    ),
  ),
);

Map<String, dynamic> _$SpeciesMovesToJson(SpeciesMoves instance) =>
    <String, dynamic>{
      'evolution': instance.evolution,
      'learning': instance.learning,
      'level': instance.level.map((k, e) => MapEntry(k.toString(), e)),
    };

EvolutionData _$EvolutionDataFromJson(Map<String, dynamic> json) =>
    EvolutionData(
      to: (json['to'] as num).toInt(),
      requires: EvolutionRequirement.fromJson(
        json['requires'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$EvolutionDataToJson(EvolutionData instance) =>
    <String, dynamic>{'to': instance.to, 'requires': instance.requires};

EvolutionRequirement _$EvolutionRequirementFromJson(
  Map<String, dynamic> json,
) => EvolutionRequirement(
  level: (json['level'] as num?)?.toInt(),
  friendship: (json['friendship'] as num?)?.toInt(),
  stone: $enumDecodeNullable(_$EvolutionStoneEnumMap, json['stone']),
  criticalHits: (json['criticalHits'] as num?)?.toInt(),
);

Map<String, dynamic> _$EvolutionRequirementToJson(
  EvolutionRequirement instance,
) => <String, dynamic>{
  'level': instance.level,
  'friendship': instance.friendship,
  'stone': _$EvolutionStoneEnumMap[instance.stone],
  'criticalHits': instance.criticalHits,
};

const _$EvolutionStoneEnumMap = {
  EvolutionStone.water: 'water',
  EvolutionStone.fire: 'fire',
  EvolutionStone.ice: 'ice',
  EvolutionStone.leaf: 'leaf',
  EvolutionStone.moon: 'moon',
  EvolutionStone.thunder: 'thunder',
};

PokemonSpecies _$PokemonSpeciesFromJson(
  Map<String, dynamic> json,
) => PokemonSpecies(
  id: (json['_id'] as num).toInt(),
  name: json['name'] as String,
  iconIdx: (json['iconIdx'] as num).toInt(),
  stage: (json['stage'] as num).toInt(),
  baseStats: PokemonStats.fromJson(json['baseStats'] as Map<String, dynamic>),
  nextLevel: NextLevelFormula.fromJson(
    json['nextLevel'] as Map<String, dynamic>,
  ),
  combatExp: (json['combatExp'] as num).toInt(),
  moves: SpeciesMoves.fromJson(json['moves'] as Map<String, dynamic>),
  types: (json['types'] as List<dynamic>)
      .map((e) => $enumDecode(_$PokemonTypeEnumMap, e))
      .toList(),
  pointImprovement: Map<String, String>.from(json['pointImprovement'] as Map),
  evolutions: (json['evolutions'] as List<dynamic>?)
      ?.map((e) => EvolutionData.fromJson(e as Map<String, dynamic>))
      .toList(),
  prevEvolution: (json['prevEvolution'] as num?)?.toInt(),
  regionalForms: (json['regionalForms'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry($enumDecode(_$RegionEnumMap, k), e as Map<String, dynamic>),
  ),
);

Map<String, dynamic> _$PokemonSpeciesToJson(PokemonSpecies instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'iconIdx': instance.iconIdx,
      'stage': instance.stage,
      'baseStats': instance.baseStats,
      'nextLevel': instance.nextLevel,
      'combatExp': instance.combatExp,
      'moves': instance.moves,
      'types': instance.types.map((e) => _$PokemonTypeEnumMap[e]!).toList(),
      'pointImprovement': instance.pointImprovement,
      'evolutions': instance.evolutions,
      'prevEvolution': instance.prevEvolution,
      'regionalForms': instance.regionalForms?.map(
        (k, e) => MapEntry(_$RegionEnumMap[k]!, e),
      ),
    };

const _$PokemonTypeEnumMap = {
  PokemonType.bug: 'bug',
  PokemonType.dark: 'dark',
  PokemonType.dragon: 'dragon',
  PokemonType.electric: 'electric',
  PokemonType.fairy: 'fairy',
  PokemonType.fire: 'fire',
  PokemonType.fighting: 'fighting',
  PokemonType.flying: 'flying',
  PokemonType.grass: 'grass',
  PokemonType.ground: 'ground',
  PokemonType.ghost: 'ghost',
  PokemonType.ice: 'ice',
  PokemonType.normal: 'normal',
  PokemonType.poison: 'poison',
  PokemonType.psychic: 'psychic',
  PokemonType.rock: 'rock',
  PokemonType.steel: 'steel',
  PokemonType.water: 'water',
};

const _$RegionEnumMap = {
  Region.alola: 'alola',
  Region.galar: 'galar',
  Region.kanto: 'kanto',
};

DbPokemon _$DbPokemonFromJson(Map<String, dynamic> json) => DbPokemon(
  id: json['id'] as String,
  species: (json['species'] as num).toInt(),
  region: $enumDecode(_$RegionEnumMap, json['region']),
  nature: json['nature'] as String,
  level: (json['level'] as num).toInt(),
  experience: (json['experience'] as num).toInt(),
  nickname: json['nickname'] as String,
  affectionPoints: (json['affectionPoints'] as num).toInt(),
  currentHp: (json['currentHp'] as num).toInt(),
  currentPp: (json['currentPp'] as num).toInt(),
  maxHpBonus: (json['maxHpBonus'] as num).toInt(),
  maxPpBonus: (json['maxPpBonus'] as num).toInt(),
  learnedMoves: (json['learnedMoves'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$DbPokemonToJson(DbPokemon instance) => <String, dynamic>{
  'id': instance.id,
  'species': instance.species,
  'region': _$RegionEnumMap[instance.region]!,
  'nature': instance.nature,
  'level': instance.level,
  'experience': instance.experience,
  'nickname': instance.nickname,
  'affectionPoints': instance.affectionPoints,
  'currentHp': instance.currentHp,
  'currentPp': instance.currentPp,
  'maxHpBonus': instance.maxHpBonus,
  'maxPpBonus': instance.maxPpBonus,
  'learnedMoves': instance.learnedMoves,
};
