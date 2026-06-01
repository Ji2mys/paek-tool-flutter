// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moves.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Move _$MoveFromJson(Map<String, dynamic> json) => Move(
  id: (json['_id'] as num).toInt(),
  name: json['name'] as String,
  moveType: $enumDecode(_$MoveTypeEnumMap, json['moveType']),
  ppCost: (json['ppCost'] as num).toInt(),
  type: $enumDecode(_$PokemonTypeEnumMap, json['type']),
  precision: (json['precision'] as num).toInt(),
  damage: json['damage'] as String?,
  effect: json['effect'] as String?,
);

Map<String, dynamic> _$MoveToJson(Move instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'moveType': _$MoveTypeEnumMap[instance.moveType]!,
  'ppCost': instance.ppCost,
  'type': _$PokemonTypeEnumMap[instance.type]!,
  'precision': instance.precision,
  'damage': instance.damage,
  'effect': instance.effect,
};

const _$MoveTypeEnumMap = {
  MoveType.physical: 'physical',
  MoveType.special: 'special',
  MoveType.status: 'status',
  MoveType.mixed: 'mixed',
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
