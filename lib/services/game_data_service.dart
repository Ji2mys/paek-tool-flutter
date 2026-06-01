import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:paek_game_tool_flutter/models/character.dart';
import 'package:paek_game_tool_flutter/models/moves.dart';
import 'package:paek_game_tool_flutter/models/pokemon.dart';

class GameDataError extends Error {
  final String message;

  GameDataError([this.message = 'Game data not loaded.']);
}

class GameDataService {
  static List<PokemonSpecies> _pokemonSpecies = [];
  static List<Profession> _professions = [];
  static List<Move> _moves = [];

  static List<PokemonSpecies> get pokemonSpecies => _pokemonSpecies;
  static List<Profession> get professions => _professions;
  static List<Move> get moves => _moves;

  static bool loading = false;

  static Future<void> loadGameData() async {
    loading = true;
    final gameDataString = await rootBundle.loadString(
      'assets/data/game-data.json',
    );
    final gameData = jsonDecode(gameDataString);

    final speciesJson = gameData['species'] as List<dynamic>;
    final professionsJson = gameData['professions'] as List<dynamic>;
    final movesJson = gameData['moves'] as List<dynamic>;
    GameDataService._pokemonSpecies = speciesJson
        .map((json) => PokemonSpecies.fromJson(json))
        .toList();
    GameDataService._professions = professionsJson
        .map((json) => Profession.fromJson(json))
        .toList();
    GameDataService._moves = movesJson
        .map((json) => Move.fromJson(json))
        .toList();
    loading = false;
  }
}
