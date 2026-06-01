import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/character.dart';
import '../models/pokemon.dart';
import 'pokemon_service.dart';

/// Flutter equivalent of the Ionic/Capacitor [CharacterService].
///
/// File layout on disk (under the app's Documents directory):
///   characters/
///     <code>characterFolderName</code>/
///       character.json
///       pokemon-team/
///         <code>pokemonId</code>.json
///       pokemon-home/
///         <code>pokemonId</code>.json
class CharacterService {
  final PokemonService _pokemonService;

  CharacterService({PokemonService? pokemonService})
    : _pokemonService = pokemonService ?? PokemonService();

  Future<Directory> get _docsDir => getApplicationDocumentsDirectory();

  /// Converts a character name into a safe folder name, mirroring the Angular
  /// implementation:
  ///   1. Replace accented/special characters with 'X'.
  ///   2. Replace whitespace sequences with '_'.
  static String _toFolderName(String name) {
    final noAccents = name.replaceAll(RegExp(r'[^A-Za-z\s]'), 'X');
    return noAccents.replaceAll(RegExp(r'\s+'), '_');
  }

  Future<void> createNewCharacter(FormCharacter formData) async {
    final talents = <Talent, int>{};

    for (final talent in formData.stats.talents) {
      talents[talent['key']] = talent['value'];
    }

    final characterId =
        "${_toFolderName(formData.info.name)}-${DateTime.now().millisecondsSinceEpoch}";
    final newDbCharacter = DBCharacter(
      id: characterId,
      name: formData.info.name,
      pronouns: formData.info.pronouns,
      age: formData.info.age,
      homeTown: formData.initialPokemon.homeTown,
      abilities: formData.stats.abilities,
      talents: talents,
      trainerLevel: 0,
      reputation: 0,
      pokeaids: 0,
      professions: [],
    );

    final initialPokemonIdx = formData.initialPokemon.initialPokemon;
    final initialPokemonNickname = formData.initialPokemon.nickname;

    final initialPokemon = PokemonService.createInitialPokemon(
      initialPokemonIdx,
      initialPokemonNickname,
      formData.initialPokemon.region,
    );

    await _pokemonService.savePokemon(initialPokemon, newDbCharacter.id);
    await saveCharacter(newDbCharacter);
  }

  Future<void> saveCharacter(DBCharacter character) async {
    final docs = await _docsDir;
    final file = File('${docs.path}/characters/${character.id}/character.json');

    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(character.toJson()));
  }

  /// Returns a lightweight [ListCharacter] for every character folder found,
  /// including the first 3 Pokémon species indexes of their team.
  Future<List<ListCharacter>> loadCharactersForList() async {
    final docs = await _docsDir;
    final charactersDir = Directory('${docs.path}/characters');
    final characters = <ListCharacter>[];

    await for (final entity in charactersDir.list()) {
      if (entity is! Directory) continue;

      final characterFile = File('${entity.path}/character.json');
      final content = await characterFile.readAsString();
      final fileData = DBCharacter.fromJson(
        jsonDecode(content) as Map<String, dynamic>,
      );

      final folderName = entity.path.split(Platform.pathSeparator).last;
      final pokemonIndexes = await _pokemonService.getPokemonTeamForList(
        folderName,
      );

      characters.add(
        ListCharacter(
          id: folderName,
          name: fileData.name,
          portrait: 'https://placehold.co/100',
          pokemon: pokemonIndexes,
        ),
      );
    }

    return characters;
  }

  /// Loads the raw [DBCharacter] for the given [uuid] (folder name).
  Future<DBCharacter> loadCharacter(String uuid) async {
    final docs = await _docsDir;
    final file = File('${docs.path}/characters/$uuid/character.json');
    final content = await file.readAsString();
    return DBCharacter.fromJson(jsonDecode(content) as Map<String, dynamic>);
  }
}
