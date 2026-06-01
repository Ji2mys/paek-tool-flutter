import 'package:json_annotation/json_annotation.dart';
import 'package:paek_game_tool_flutter/models/pokemon.dart';

part 'moves.g.dart';

enum MoveType { physical, special, status, mixed }

@JsonSerializable()
class Move {
  @JsonKey(name: "_id")
  final int id;
  final String name;
  final MoveType moveType;
  final int ppCost;
  final PokemonType type;
  final int precision;
  final String? damage;
  final String? effect;

  const Move({
    required this.id,
    required this.name,
    required this.moveType,
    required this.ppCost,
    required this.type,
    required this.precision,
    this.damage,
    this.effect,
  });

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);
  Map<String, dynamic> toJson() => _$MoveToJson(this);
}
