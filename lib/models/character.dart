import 'package:json_annotation/json_annotation.dart';
import 'package:paek_game_tool_flutter/models/pokemon.dart';

part 'character.g.dart';

@JsonSerializable()
class AbilitiesDict {
  int charisma;
  int physique;
  int intelligence;
  int pokeworld;
  int insight;

  AbilitiesDict({
    this.charisma = 0,
    this.physique = 0,
    this.intelligence = 0,
    this.pokeworld = 0,
    this.insight = 0,
  });

  factory AbilitiesDict.fromJson(Map<String, dynamic> json) =>
      _$AbilitiesDictFromJson(json);

  Map<String, dynamic> toJson() => _$AbilitiesDictToJson(this);
}

@JsonSerializable()
class PokemonMovesProfessionRequirement {
  final List<int> idxs;
  final String description;

  PokemonMovesProfessionRequirement({
    required this.idxs,
    required this.description,
  });

  factory PokemonMovesProfessionRequirement.fromJson(
    Map<String, dynamic> json,
  ) => _$PokemonMovesProfessionRequirementFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PokemonMovesProfessionRequirementToJson(this);
}

@JsonSerializable()
class PokemonProfessionRequirement {
  final PokemonType? ofType;
  final int? atLevel;
  final PokemonMovesProfessionRequirement? withMoveOfGroup;

  const PokemonProfessionRequirement({
    this.ofType,
    this.atLevel,
    this.withMoveOfGroup,
  });

  factory PokemonProfessionRequirement.fromJson(Map<String, dynamic> json) =>
      _$PokemonProfessionRequirementFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonProfessionRequirementToJson(this);
}

@JsonSerializable()
class ProfessionRequirements {
  final Map<Ability, int>? abilities;
  final Map<Talent, int>? talents;
  final PokemonProfessionRequirement? pokemon;

  const ProfessionRequirements({this.abilities, this.talents, this.pokemon});

  factory ProfessionRequirements.fromJson(Map<String, dynamic> json) =>
      _$ProfessionRequirementsFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionRequirementsToJson(this);
}

@JsonSerializable()
class DamageProfessionBonus {
  final int amount;
  final bool? toAllPokemon;
  final PokemonType? toType;
  final bool? toAllTypes;
  final List<int>? toMoveGroup;
  final String? attackDescription;
  final List<int>? toPokemonGroup;

  const DamageProfessionBonus({
    required this.amount,
    this.toAllPokemon,
    this.toType,
    this.toAllTypes,
    this.toMoveGroup,
    this.attackDescription,
    this.toPokemonGroup,
  });

  factory DamageProfessionBonus.fromJson(Map<String, dynamic> json) =>
      _$DamageProfessionBonusFromJson(json);

  Map<String, dynamic> toJson() => _$DamageProfessionBonusToJson(this);
}

@JsonSerializable()
class ConditionProfessionBonus {
  final List<String> ofType;
  final int damagePerTurn;

  const ConditionProfessionBonus({
    required this.ofType,
    required this.damagePerTurn,
  });

  factory ConditionProfessionBonus.fromJson(Map<String, dynamic> json) =>
      _$ConditionProfessionBonusFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionProfessionBonusToJson(this);
}

@JsonSerializable()
class ProfessionBonus {
  final int? healing;
  final int? exp;
  final int? pokeaids;
  final DamageProfessionBonus? damage;
  final ConditionProfessionBonus? conditions;

  const ProfessionBonus({
    this.healing,
    this.exp,
    this.pokeaids,
    this.damage,
    this.conditions,
  });

  factory ProfessionBonus.fromJson(Map<String, dynamic> json) =>
      _$ProfessionBonusFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionBonusToJson(this);
}

@JsonSerializable()
class ProfessionTalents {
  final Talent? primary;
  final List<Talent>? secondary;

  ProfessionTalents({this.primary, this.secondary});

  factory ProfessionTalents.fromJson(Map<String, dynamic> json) =>
      _$ProfessionTalentsFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionTalentsToJson(this);
}

@JsonSerializable()
class Profession {
  final String id;
  final ProfessionRequirements? requirements;
  final ProfessionTalents? talents;
  @JsonKey(defaultValue: false)
  final bool anyTalentAsPrimary;
  @JsonKey(defaultValue: false)
  final bool generalTalentsAsSecondary;
  @JsonKey(defaultValue: false)
  final bool specificTalentsAsSecondary;
  final ProfessionBonus? upgrade;
  final int income;
  final bool? narrative;

  const Profession({
    required this.id,
    this.requirements,
    this.talents,
    required this.anyTalentAsPrimary,
    required this.generalTalentsAsSecondary,
    required this.specificTalentsAsSecondary,
    required this.upgrade,
    required this.income,
    this.narrative,
  });

  factory Profession.fromJson(Map<String, dynamic> json) =>
      _$ProfessionFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionToJson(this);
}

@JsonSerializable()
class CharacterProfession {
  final String id;
  final int trainerLevel;
  final Map<String, dynamic> params;

  const CharacterProfession({
    required this.id,
    required this.trainerLevel,
    required this.params,
  });

  factory CharacterProfession.fromJson(Map<String, dynamic> json) =>
      _$CharacterProfessionFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterProfessionToJson(this);
}

enum Ability { intelligence, insight, charisma, physique, pokeworld }

enum Talent {
  athletics,
  perceive,
  cook,
  drive,
  convince,
  nursing,
  deceive,
  geography,
  music,
  swim,
  fish,
  stealth,
  tech,
  vigor,
  martialArts,
  science,
  spiritism,
  mechanics,
  ninjutsu,
  psyche,
  thievery,
  survival,
}

class ListCharacter {
  final String id;
  final String portrait;
  final String name;
  final List<int> pokemon;

  const ListCharacter({
    required this.id,
    required this.portrait,
    required this.name,
    required this.pokemon,
  });
}

@JsonSerializable()
class DBCharacter {
  String id;
  String name;
  String pronouns;
  String homeTown;
  int pokeaids;
  int age;
  int reputation;
  int trainerLevel;
  AbilitiesDict abilities;
  Map<Talent, int> talents;
  List<CharacterProfession> professions;

  DBCharacter({
    required this.id,
    required this.name,
    required this.pronouns,
    required this.homeTown,
    required this.pokeaids,
    required this.age,
    required this.reputation,
    required this.trainerLevel,
    required this.abilities,
    required this.talents,
    required this.professions,
  });

  factory DBCharacter.fromJson(Map<String, dynamic> json) =>
      _$DBCharacterFromJson(json);

  Map<String, dynamic> toJson() => _$DBCharacterToJson(this);
}

class FormCharacterInfo {
  final String name;
  final String pronouns;
  final int age;

  const FormCharacterInfo({
    required this.name,
    required this.pronouns,
    required this.age,
  });
}

class FormCharacterInitialPokemon {
  final String homeTown;
  final int initialPokemon;
  final String nickname;
  final Region region;

  const FormCharacterInitialPokemon({
    required this.homeTown,
    required this.initialPokemon,
    required this.nickname,
    this.region = Region.kanto,
  });
}

class FormCharacterStats {
  final AbilitiesDict abilities;
  final List<Map<String, dynamic>> talents;

  const FormCharacterStats({required this.abilities, required this.talents});
}

class FormCharacter {
  final FormCharacterInfo info;
  final FormCharacterInitialPokemon initialPokemon;
  final FormCharacterStats stats;

  const FormCharacter({
    required this.info,
    required this.initialPokemon,
    required this.stats,
  });
}
