import 'package:flutter/material.dart';
import 'package:paek_game_tool_flutter/models/character.dart';
import 'package:paek_game_tool_flutter/pages/new_character_page.dart';
import 'package:paek_game_tool_flutter/services/character_service.dart';
import 'package:paek_game_tool_flutter/services/game_data_service.dart';
import 'package:paek_game_tool_flutter/widgets/character_entry.dart';

/// Flutter equivalent of the Angular [CharacterListPage].
///
/// Shows a [ListView] of [CharacterEntry] cards, or a welcome/empty-state
/// message when no characters have been created yet.
///
/// A floating [FloatingActionButton] (bottom-right) will eventually navigate
/// to the new-character creation flow.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharacterService _characterService = CharacterService();

  List<ListCharacter> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    GameDataService.loadGameData().then((_) {
      _loadCharacters();
    });
  }

  Future<void> _loadCharacters() async {
    try {
      final loaded = await _characterService.loadCharactersForList();
      if (mounted) {
        setState(() {
          _characters = loaded;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes'), centerTitle: false),
      body: _isLoading ? _buildLoader() : _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewCharacterPage()),
          );
          // Reload list after returning in case a character was saved.
          if (mounted) _loadCharacters();
        },
        tooltip: 'Nuevo personaje',
        child: const Icon(Icons.person_add_outlined),
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBody(BuildContext context) {
    if (_characters.isEmpty) {
      return _buildWelcomeMessage(context);
    }
    return _buildCharacterList();
  }

  /// Welcome / empty-state screen shown when no characters exist yet.
  Widget _buildWelcomeMessage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¡Bienvenido!',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Recuerda que para usar esta app necesitarás conocer las reglas de '
              'Pokémon: Aventuras en Kanto. Si no tienes el manual aún, puedes '
              'descargarlo en la página web de Unai Rojo.',
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Si ya lo tienes, dale al botón de abajo para crear tu primer personaje.',
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Scrollable list of [CharacterEntry] cards.
  Widget _buildCharacterList() {
    return RefreshIndicator(
      onRefresh: _loadCharacters,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _characters.length,
        itemBuilder: (context, index) {
          final character = _characters[index];
          return CharacterEntry(
            character: character,
            onTap: () {
              // TODO: Navigate to character sheet.
              // Navigator.pushNamed(context, '/characters/${character.id}/sheet');
            },
          );
        },
      ),
    );
  }
}
