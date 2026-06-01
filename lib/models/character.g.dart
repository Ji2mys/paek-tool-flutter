// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbilitiesDict _$AbilitiesDictFromJson(Map<String, dynamic> json) =>
    AbilitiesDict(
      charisma: (json['charisma'] as num?)?.toInt() ?? 0,
      physique: (json['physique'] as num?)?.toInt() ?? 0,
      intelligence: (json['intelligence'] as num?)?.toInt() ?? 0,
      pokeworld: (json['pokeworld'] as num?)?.toInt() ?? 0,
      insight: (json['insight'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AbilitiesDictToJson(AbilitiesDict instance) =>
    <String, dynamic>{
      'charisma': instance.charisma,
      'physique': instance.physique,
      'intelligence': instance.intelligence,
      'pokeworld': instance.pokeworld,
      'insight': instance.insight,
    };

PokemonMovesProfessionRequirement _$PokemonMovesProfessionRequirementFromJson(
  Map<String, dynamic> json,
) => PokemonMovesProfessionRequirement(
  idxs: (json['idxs'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  description: json['description'] as String,
);

Map<String, dynamic> _$PokemonMovesProfessionRequirementToJson(
  PokemonMovesProfessionRequirement instance,
) => <String, dynamic>{
  'idxs': instance.idxs,
  'description': instance.description,
};

PokemonProfessionRequirement _$PokemonProfessionRequirementFromJson(
  Map<String, dynamic> json,
) => PokemonProfessionRequirement(
  ofType: $enumDecodeNullable(_$PokemonTypeEnumMap, json['ofType']),
  atLevel: (json['atLevel'] as num?)?.toInt(),
  withMoveOfGroup: json['withMoveOfGroup'] == null
      ? null
      : PokemonMovesProfessionRequirement.fromJson(
          json['withMoveOfGroup'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PokemonProfessionRequirementToJson(
  PokemonProfessionRequirement instance,
) => <String, dynamic>{
  'ofType': _$PokemonTypeEnumMap[instance.ofType],
  'atLevel': instance.atLevel,
  'withMoveOfGroup': instance.withMoveOfGroup,
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

ProfessionRequirements _$ProfessionRequirementsFromJson(
  Map<String, dynamic> json,
) => ProfessionRequirements(
  abilities: (json['abilities'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry($enumDecode(_$AbilityEnumMap, k), (e as num).toInt()),
  ),
  talents: (json['talents'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry($enumDecode(_$TalentEnumMap, k), (e as num).toInt()),
  ),
  pokemon: json['pokemon'] == null
      ? null
      : PokemonProfessionRequirement.fromJson(
          json['pokemon'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ProfessionRequirementsToJson(
  ProfessionRequirements instance,
) => <String, dynamic>{
  'abilities': instance.abilities?.map(
    (k, e) => MapEntry(_$AbilityEnumMap[k]!, e),
  ),
  'talents': instance.talents?.map((k, e) => MapEntry(_$TalentEnumMap[k]!, e)),
  'pokemon': instance.pokemon,
};

const _$AbilityEnumMap = {
  Ability.intelligence: 'intelligence',
  Ability.insight: 'insight',
  Ability.charisma: 'charisma',
  Ability.physique: 'physique',
  Ability.pokeworld: 'pokeworld',
};

const _$TalentEnumMap = {
  Talent.athletics: 'athletics',
  Talent.perceive: 'perceive',
  Talent.cook: 'cook',
  Talent.drive: 'drive',
  Talent.convince: 'convince',
  Talent.nursing: 'nursing',
  Talent.deceive: 'deceive',
  Talent.geography: 'geography',
  Talent.music: 'music',
  Talent.swim: 'swim',
  Talent.fish: 'fish',
  Talent.stealth: 'stealth',
  Talent.tech: 'tech',
  Talent.vigor: 'vigor',
  Talent.martialArts: 'martialArts',
  Talent.science: 'science',
  Talent.spiritism: 'spiritism',
  Talent.mechanics: 'mechanics',
  Talent.ninjutsu: 'ninjutsu',
  Talent.psyche: 'psyche',
  Talent.thievery: 'thievery',
  Talent.survival: 'survival',
};

DamageProfessionBonus _$DamageProfessionBonusFromJson(
  Map<String, dynamic> json,
) => DamageProfessionBonus(
  amount: (json['amount'] as num).toInt(),
  toAllPokemon: json['toAllPokemon'] as bool?,
  toType: $enumDecodeNullable(_$PokemonTypeEnumMap, json['toType']),
  toAllTypes: json['toAllTypes'] as bool?,
  toMoveGroup: (json['toMoveGroup'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  attackDescription: json['attackDescription'] as String?,
  toPokemonGroup: (json['toPokemonGroup'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$DamageProfessionBonusToJson(
  DamageProfessionBonus instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'toAllPokemon': instance.toAllPokemon,
  'toType': _$PokemonTypeEnumMap[instance.toType],
  'toAllTypes': instance.toAllTypes,
  'toMoveGroup': instance.toMoveGroup,
  'attackDescription': instance.attackDescription,
  'toPokemonGroup': instance.toPokemonGroup,
};

ConditionProfessionBonus _$ConditionProfessionBonusFromJson(
  Map<String, dynamic> json,
) => ConditionProfessionBonus(
  ofType: (json['ofType'] as List<dynamic>).map((e) => e as String).toList(),
  damagePerTurn: (json['damagePerTurn'] as num).toInt(),
);

Map<String, dynamic> _$ConditionProfessionBonusToJson(
  ConditionProfessionBonus instance,
) => <String, dynamic>{
  'ofType': instance.ofType,
  'damagePerTurn': instance.damagePerTurn,
};

ProfessionBonus _$ProfessionBonusFromJson(Map<String, dynamic> json) =>
    ProfessionBonus(
      healing: (json['healing'] as num?)?.toInt(),
      exp: (json['exp'] as num?)?.toInt(),
      pokeaids: (json['pokeaids'] as num?)?.toInt(),
      damage: json['damage'] == null
          ? null
          : DamageProfessionBonus.fromJson(
              json['damage'] as Map<String, dynamic>,
            ),
      conditions: json['conditions'] == null
          ? null
          : ConditionProfessionBonus.fromJson(
              json['conditions'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProfessionBonusToJson(ProfessionBonus instance) =>
    <String, dynamic>{
      'healing': instance.healing,
      'exp': instance.exp,
      'pokeaids': instance.pokeaids,
      'damage': instance.damage,
      'conditions': instance.conditions,
    };

ProfessionTalents _$ProfessionTalentsFromJson(Map<String, dynamic> json) =>
    ProfessionTalents(
      primary: $enumDecodeNullable(_$TalentEnumMap, json['primary']),
      secondary: (json['secondary'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$TalentEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$ProfessionTalentsToJson(ProfessionTalents instance) =>
    <String, dynamic>{
      'primary': _$TalentEnumMap[instance.primary],
      'secondary': instance.secondary?.map((e) => _$TalentEnumMap[e]!).toList(),
    };

Profession _$ProfessionFromJson(Map<String, dynamic> json) => Profession(
  id: json['id'] as String,
  requirements: json['requirements'] == null
      ? null
      : ProfessionRequirements.fromJson(
          json['requirements'] as Map<String, dynamic>,
        ),
  talents: json['talents'] == null
      ? null
      : ProfessionTalents.fromJson(json['talents'] as Map<String, dynamic>),
  anyTalentAsPrimary: json['anyTalentAsPrimary'] as bool? ?? false,
  generalTalentsAsSecondary:
      json['generalTalentsAsSecondary'] as bool? ?? false,
  specificTalentsAsSecondary:
      json['specificTalentsAsSecondary'] as bool? ?? false,
  upgrade: json['upgrade'] == null
      ? null
      : ProfessionBonus.fromJson(json['upgrade'] as Map<String, dynamic>),
  income: (json['income'] as num).toInt(),
  narrative: json['narrative'] as bool?,
);

Map<String, dynamic> _$ProfessionToJson(Profession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requirements': instance.requirements,
      'talents': instance.talents,
      'anyTalentAsPrimary': instance.anyTalentAsPrimary,
      'generalTalentsAsSecondary': instance.generalTalentsAsSecondary,
      'specificTalentsAsSecondary': instance.specificTalentsAsSecondary,
      'upgrade': instance.upgrade,
      'income': instance.income,
      'narrative': instance.narrative,
    };

CharacterProfession _$CharacterProfessionFromJson(Map<String, dynamic> json) =>
    CharacterProfession(
      id: json['id'] as String,
      trainerLevel: (json['trainerLevel'] as num).toInt(),
      params: json['params'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CharacterProfessionToJson(
  CharacterProfession instance,
) => <String, dynamic>{
  'id': instance.id,
  'trainerLevel': instance.trainerLevel,
  'params': instance.params,
};

DBCharacter _$DBCharacterFromJson(Map<String, dynamic> json) => DBCharacter(
  id: json['id'] as String,
  name: json['name'] as String,
  pronouns: json['pronouns'] as String,
  homeTown: json['homeTown'] as String,
  pokeaids: (json['pokeaids'] as num).toInt(),
  age: (json['age'] as num).toInt(),
  reputation: (json['reputation'] as num).toInt(),
  trainerLevel: (json['trainerLevel'] as num).toInt(),
  abilities: AbilitiesDict.fromJson(json['abilities'] as Map<String, dynamic>),
  talents: (json['talents'] as Map<String, dynamic>).map(
    (k, e) => MapEntry($enumDecode(_$TalentEnumMap, k), (e as num).toInt()),
  ),
  professions: (json['professions'] as List<dynamic>)
      .map((e) => CharacterProfession.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DBCharacterToJson(
  DBCharacter instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'pronouns': instance.pronouns,
  'homeTown': instance.homeTown,
  'pokeaids': instance.pokeaids,
  'age': instance.age,
  'reputation': instance.reputation,
  'trainerLevel': instance.trainerLevel,
  'abilities': instance.abilities,
  'talents': instance.talents.map((k, e) => MapEntry(_$TalentEnumMap[k]!, e)),
  'professions': instance.professions,
};
