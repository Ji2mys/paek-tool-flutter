import 'dart:convert';
import 'dart:io';

import 'package:paek_game_tool_flutter/services/game_data_service.dart';
import 'package:path_provider/path_provider.dart';

import '../models/pokemon.dart';

/// Flutter equivalent of the Ionic/Capacitor [PokemonService].
///
/// All file operations use [path_provider] + [dart:io] in place of
/// `@capacitor/filesystem`. The Documents directory (Directory.Documents)
/// maps to [getApplicationDocumentsDirectory].
class PokemonService {
  Future<Directory> get _docsDir => getApplicationDocumentsDirectory();

  Future<File> _pokemonFile(
    String characterFolderName,
    String destination,
    String pokemonId,
  ) async {
    final docs = await _docsDir;
    return File(
      '${docs.path}/characters/$characterFolderName/$destination/$pokemonId.json',
    );
  }

  Future<Directory> _teamFolder(String characterId) async {
    final docs = await _docsDir;
    return Directory('${docs.path}/characters/$characterId/pokemon-team');
  }

  static PokemonSpecies getPokemonSpecies(int speciesIdx, Region region) {
    final species = GameDataService.pokemonSpecies;
    if (species.isEmpty) {
      throw GameDataError();
    }

    final baseSpecies = GameDataService.pokemonSpecies.firstWhere(
      (s) => s.id == speciesIdx,
    );

    if (region == Region.kanto) {
      return baseSpecies;
    }

    if (baseSpecies.regionalForms?[region] != null) {
      final regionalForm = baseSpecies.regionalForms![region]!;
      final mergedObject = {
        ...(jsonDecode(jsonEncode(baseSpecies)) as Map<String, dynamic>),
        ...regionalForm,
      };
      return PokemonSpecies.fromJson(mergedObject);
    }

    throw UnimplementedError();
  }

  /// Creates a brand new [PokemonIndividual] for a starting Pokémon.
  static PokemonIndividual createInitialPokemon(
    int speciesIdx,
    String nickname,
    Region region,
  ) {
    return PokemonIndividual.createInitial(speciesIdx, nickname, region);
  }

  /// Saves [pokemon] to the character's `pokemon-team` folder.
  /// If the team already has 6 members, saves to `pokemon-home` instead
  /// (mirrors the Angular service behaviour).
  Future<void> savePokemon(
    PokemonIndividual pokemon,
    String characterId,
  ) async {
    final dbPokemon = pokemon.toDbPokemon();
    String destination = 'pokemon-team';

    try {
      final teamDir = await _teamFolder(characterId);
      final files = await teamDir.list().toList();
      if (files.length >= 6) {
        destination = 'pokemon-home';
      }
    } catch (_) {
      // Folder does not exist yet — first Pokémon, keep 'pokemon-team'.
    }

    final file = await _pokemonFile(characterId, destination, dbPokemon.id);
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(dbPokemon.toJson()));
  }

  /// Returns up to 3 species indexes from the character's team —
  /// used for quick list previews (mirrors [getPokemonTeamForList]).
  Future<List<int>> getPokemonTeamForList(String characterFolderName) async {
    final teamDir = await _teamFolder(characterFolderName);
    final pokemonIndexes = <int>[];

    await for (final entity in teamDir.list()) {
      if (entity is! File) continue;
      final content = await entity.readAsString();
      final dbPokemon = DbPokemon.fromJson(
        jsonDecode(content) as Map<String, dynamic>,
      );
      final pokemonInstance = PokemonIndividual.fromDbPokemon(dbPokemon);
      pokemonIndexes.add(pokemonInstance.iconIdx);
    }

    return pokemonIndexes.take(3).toList();
  }

  /// Loads and deserialises every Pokémon in the character's team folder.
  Future<List<PokemonIndividual>> getPokemonTeam(String characterId) async {
    final teamDir = await _teamFolder(characterId);
    final pokemon = <PokemonIndividual>[];

    await for (final entity in teamDir.list()) {
      if (entity is! File) continue;
      final content = await entity.readAsString();
      final dbPokemon = DbPokemon.fromJson(
        jsonDecode(content) as Map<String, dynamic>,
      );
      pokemon.add(PokemonIndividual.fromDbPokemon(dbPokemon));
    }

    return pokemon;
  }

  /// Loads a single Pokémon by its [pokemonId] from the character's team.
  Future<PokemonIndividual> getPokemon(
    String characterId,
    String pokemonId,
  ) async {
    final docs = await _docsDir;
    final file = File(
      '${docs.path}/characters/$characterId/pokemon-team/$pokemonId.json',
    );
    final content = await file.readAsString();
    final dbPokemon = DbPokemon.fromJson(
      jsonDecode(content) as Map<String, dynamic>,
    );
    return PokemonIndividual.fromDbPokemon(dbPokemon);
  }
}
