import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paek_game_tool_flutter/l10n/app_localizations.dart';
import 'package:paek_game_tool_flutter/models/pokemon.dart';
import 'package:paek_game_tool_flutter/services/pokemon_service.dart';

import '../data/character_data.dart';
import '../data/pokemon_data.dart';
import '../models/character.dart';
import '../services/character_service.dart';
import '../widgets/pokemon_icon.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Weighted-random pick from a probability map. Returns the selected key.
InitialPokemonData _weightedRand(List<InitialPokemonData> spec) {
  final r = Random().nextDouble();
  double sum = 0;
  for (final e in spec) {
    sum += e.odds;
    if (r <= sum) return e;
  }
  return spec.first;
}

class InitialPokemonOption {
  final int id;
  final String name;
  final Region region;
  final int iconIdx;

  const InitialPokemonOption({
    required this.id,
    required this.name,
    required this.region,
    required this.iconIdx,
  });
}

// ─── Page ────────────────────────────────────────────────────────────────────

class NewCharacterPage extends StatefulWidget {
  const NewCharacterPage({super.key});

  @override
  State<NewCharacterPage> createState() => _NewCharacterPageState();
}

class _NewCharacterPageState extends State<NewCharacterPage> {
  final _characterService = CharacterService();

  int _step = 0;
  bool _canGoNext = false;
  bool _submitting = false;
  bool _usedSpecial = false;

  // Stage data
  String _name = '';
  String _pronouns = '';
  int _age = 18;
  String? _homeTown;
  Region _region = Region.kanto;
  int? _pokemonId;
  String _nickname = '';
  AbilitiesDict _abilities = AbilitiesDict();
  List<Map<String, dynamic>> _talents = [];

  void _onInfoValid(bool v, String name, String pronouns, int age) =>
      setState(() {
        _canGoNext = v;
        _name = name;
        _pronouns = pronouns;
        _age = age;
      });

  void _onPokemonValid(
    bool v,
    String? town,
    int? id,
    String nick,
    bool special,
    Region region,
  ) => setState(() {
    _canGoNext = v;
    _homeTown = town;
    _pokemonId = id;
    _region = region;
    _nickname = nick;
    _usedSpecial = special;
  });

  void _onStatsValid(
    bool v,
    AbilitiesDict ab,
    List<Map<String, dynamic>> tal,
  ) => setState(() {
    _canGoNext = v;
    _abilities = ab;
    _talents = tal;
  });

  Future<void> _next() async {
    if (!_canGoNext || _submitting) return;
    if (_step < 2) {
      setState(() {
        _step++;
        _canGoNext = false;
      });
      return;
    }
    setState(() {
      _submitting = true;
      _canGoNext = false;
    });
    await _characterService.createNewCharacter(
      FormCharacter(
        info: FormCharacterInfo(name: _name, pronouns: _pronouns, age: _age),
        initialPokemon: FormCharacterInitialPokemon(
          homeTown: _homeTown!,
          initialPokemon: _pokemonId!,
          region: _region,
          nickname: _nickname,
        ),
        stats: FormCharacterStats(abilities: _abilities, talents: _talents),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labels = ['Información', 'Pokémon inicial', 'Estadísticas'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Personaje'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _StepIndicator(current: _step, labels: labels),
        ),
      ),
      body: IndexedStack(
        index: _step,
        children: [
          _InfoStage(onChanged: _onInfoValid),
          _PokemonStage(onChanged: _onPokemonValid),
          _StatsStage(usedSpecial: _usedSpecial, onChanged: _onStatsValid),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: (_canGoNext && !_submitting) ? _next : null,
            icon: _submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(_step == 2 ? Icons.save_outlined : Icons.arrow_forward),
            label: Text(
              _submitting
                  ? 'Guardando…'
                  : (_step == 2 ? 'Finalizar' : 'Siguiente'),
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Step indicator ──────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.current, required this.labels});
  final int current;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            // connector line
            final seg = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: seg < current ? color : color.withAlpha(40),
              ),
            );
          }
          final idx = i ~/ 2;
          final done = idx < current;
          final active = idx == current;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (done || active) ? color : color.withAlpha(40),
                ),
                child: Icon(
                  done ? Icons.check : Icons.circle,
                  size: done ? 16 : 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                labels[idx],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: active ? color : Colors.grey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Stage 1 — Información ───────────────────────────────────────────────────

class _InfoStage extends StatefulWidget {
  const _InfoStage({required this.onChanged});
  final void Function(bool valid, String name, String pronouns, int age)
  onChanged;

  @override
  State<_InfoStage> createState() => _InfoStageState();
}

class _InfoStageState extends State<_InfoStage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _pronouns = '';
  int _age = 18;

  void _notify() {
    final ok = _formKey.currentState?.validate() ?? false;
    widget.onChanged(ok, _name, _pronouns, _age);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información Principal',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu personaje necesita un nombre, un pronombre y una edad. Adelante.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              initialValue: _name,
              onChanged: (v) {
                _name = v;
                _notify();
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Obligatorio';
                if (v.length < 2 || v.length > 15) {
                  return 'Entre 2 y 15 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Pronombres',
                hintText: 'Él, Ella…',
                border: OutlineInputBorder(),
              ),
              initialValue: _pronouns,
              onChanged: (v) {
                _pronouns = v;
                _notify();
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Obligatorio';
                if (v.length < 2 || v.length > 10) {
                  return 'Entre 2 y 10 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              initialValue: '$_age',
              onChanged: (v) {
                _age = int.tryParse(v) ?? _age;
                _notify();
              },
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null) return 'Obligatorio';
                if (n < 5 || n > 100) return 'Número entre 5 y 100';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stage 2 — Pokémon inicial ───────────────────────────────────────────────

class _PokemonStage extends StatefulWidget {
  const _PokemonStage({required this.onChanged});
  final void Function(
    bool valid,
    String? town,
    int? id,
    String nick,
    bool special,
    Region region,
  )
  onChanged;

  @override
  State<_PokemonStage> createState() => _PokemonStageState();
}

class _PokemonStageState extends State<_PokemonStage> {
  String? _town;
  int? _pokemonId;
  String _nickname = '';
  bool _useSpecial = false;
  bool _pickFromThree = false;
  bool _generated = false;
  bool _canRandTown = true;
  Region _region = Region.kanto;

  List<InitialPokemonOption> _options = [];
  InitialPokemonOption? _singleResult;

  void _notify(bool valid) => widget.onChanged(
    valid,
    _town,
    _pokemonId,
    _nickname,
    _useSpecial,
    _region,
  );

  List<InitialPokemonData> get _distribution =>
      initialPokemons[_useSpecial ? 'special' : (_town ?? '')] ?? [];

  void _onTownChanged(String? v) {
    if (_generated) return;
    setState(() => _town = v);
    _notify(false);
  }

  void _randomTown() {
    if (!_canRandTown || _generated) return;
    final keys = cities.keys.toList();
    final pick = keys[Random().nextInt(keys.length)];
    setState(() {
      _town = pick;
      _canRandTown = false;
    });
    _notify(false);
  }

  void _generate() {
    if (_distribution.isEmpty) return;
    if (_pickFromThree) {
      final picked = <InitialPokemonData>{};
      while (picked.length < 3) {
        picked.add(_weightedRand(_distribution));
      }
      setState(() {
        _options = picked.map((e) {
          final spec = PokemonService.getPokemonSpecies(e.speciesIdx, e.region);
          return InitialPokemonOption(
            id: e.speciesIdx,
            name: spec.name,
            region: e.region,
            iconIdx: spec.iconIdx,
          );
        }).toList();
        _generated = true;
      });
    } else {
      final randomPkmn = _weightedRand(_distribution);
      setState(() {
        final spec = PokemonService.getPokemonSpecies(
          randomPkmn.speciesIdx,
          randomPkmn.region,
        );
        _singleResult = InitialPokemonOption(
          id: randomPkmn.speciesIdx,
          name: spec.name,
          region: randomPkmn.region,
          iconIdx: spec.iconIdx,
        );
        _pokemonId = randomPkmn.speciesIdx;
        _generated = true;
      });
      _notify(true);
    }
    if (_useSpecial) {
      widget.onChanged(false, _town, null, _nickname, true, _region);
    }
  }

  void _selectOption(int id, Region region) {
    setState(() {
      _pokemonId = id;
      _region = region;
    });
    _notify(true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tu Pokémon inicial se elegirá aleatoriamente según tu ciudad natal.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _town,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad Natal',
                    border: OutlineInputBorder(),
                  ),
                  items: cities.entries
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value.label),
                        ),
                      )
                      .toList(),
                  onChanged: _generated ? null : _onTownChanged,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: (_canRandTown && !_generated) ? _randomTown : null,
                child: const Text('Aleatoria'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!_generated) ...[
            CheckboxListTile(
              value: _useSpecial,
              title: const Text('Usar tabla Especial'),
              subtitle: _useSpecial
                  ? const Text(
                      'Reduce los puntos de talento a 7.',
                      style: TextStyle(fontSize: 12),
                    )
                  : null,
              onChanged: (v) => setState(() => _useSpecial = v ?? false),
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              value: _pickFromThree,
              title: const Text('Elegir de entre tres'),
              subtitle: _pickFromThree
                  ? const Text(
                      'Elige entre 3 Pokémon aleatorios.',
                      style: TextStyle(fontSize: 12),
                    )
                  : null,
              onChanged: (v) => setState(() => _pickFromThree = v ?? false),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: (_town != null || _useSpecial) ? _generate : null,
              child: const Text('¡Vamos!'),
            ),
          ],
          if (_generated) ...[
            const SizedBox(height: 20),
            if (_options.isNotEmpty) ...[
              Text(
                'Elige tu Pokémon:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _options
                    .map(
                      (option) => GestureDetector(
                        onTap: _pokemonId == option.id
                            ? null
                            : () => _selectOption(option.id, option.region),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _pokemonId == option.id
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: _pokemonId == option.id
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              PokemonIcon(iconIdx: option.iconIdx),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.pkmnName(option.name, option.region.name),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ] else if (_singleResult != null) ...[
              Center(
                child: Column(
                  children: [
                    PokemonIcon(iconIdx: _singleResult!.iconIdx, size: 96),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.pkmnName(
                        _singleResult!.name,
                        _singleResult!.region.name,
                      ),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
            if (_pokemonId != null) ...[
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Mote (opcional)',
                  hintText: 'Pokémon #$_pokemonId',
                  border: const OutlineInputBorder(),
                ),
                onChanged: (v) {
                  _nickname = v;
                  _notify(true);
                },
                validator: (v) {
                  if (v != null && v.length == 1) {
                    return 'Mínimo 2 caracteres o déjalo vacío';
                  }
                  return null;
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ─── Stage 3 — Estadísticas ──────────────────────────────────────────────────

class _StatsStage extends StatefulWidget {
  const _StatsStage({required this.usedSpecial, required this.onChanged});
  final bool usedSpecial;
  final void Function(
    bool valid,
    AbilitiesDict abilities,
    List<Map<String, dynamic>> talents,
  )
  onChanged;

  @override
  State<_StatsStage> createState() => _StatsStageState();
}

class _StatsStageState extends State<_StatsStage> {
  static const _abilityKeys = [
    'charisma',
    'physique',
    'intelligence',
    'pokeworld',
    'insight',
  ];
  static const _abilityLabels = [
    'Carisma',
    'Físico',
    'Inteligencia',
    'Poke-mundo',
    'Perspicacia',
  ];

  final Map<String, int> _abilities = {
    'charisma': 3,
    'physique': 3,
    'intelligence': 3,
    'pokeworld': 3,
    'insight': 3,
  };

  // Each talent: {key, value}
  List<Map<String, dynamic>> _talents = [
    {'key': Talent.athletics, 'value': 1},
    {'key': Talent.perceive, 'value': 1},
  ];

  int get _abilitySum => _abilities.values.fold(0, (a, b) => a + b);
  int get _talentTotal => _talents.fold(0, (s, t) => s + (t['value'] as int));
  int get _talentBudget => widget.usedSpecial ? 7 : 10;
  Set<String> get _usedTalentKeys =>
      _talents.map((t) => (t['key'] as Talent).name).toSet();

  String? get _abilityError {
    final zeros = _abilities.values.where((v) => v == 0).length;
    final sixes = _abilities.values.where((v) => v == 6).length;
    if (zeros > 1) return 'Solo una capacidad puede valer 0.';
    if (sixes > 1) return 'Solo una capacidad puede valer 6.';
    if (_abilitySum < 15) {
      return 'La suma debe ser 15. Añade ${15 - _abilitySum} punto(s).';
    }
    if (_abilitySum > 15) {
      return 'La suma debe ser 15. Retira ${_abilitySum - 15} punto(s).';
    }
    return null;
  }

  String? get _talentError {
    if (_talents.length < 2) return 'Mínimo 2 talentos.';
    if (_talents.length > 5) return 'Máximo 5 talentos.';
    if (_talentTotal < _talentBudget) {
      return 'Distribuye $_talentBudget puntos. Te faltan ${_talentBudget - _talentTotal}.';
    }
    if (_talentTotal > _talentBudget) {
      return 'Distribuye $_talentBudget puntos. Te sobran ${_talentTotal - _talentBudget}.';
    }
    return null;
  }

  bool get _valid => _abilityError == null && _talentError == null;

  void _notify() {
    final ab = AbilitiesDict(
      charisma: _abilities['charisma']!,
      physique: _abilities['physique']!,
      intelligence: _abilities['intelligence']!,
      pokeworld: _abilities['pokeworld']!,
      insight: _abilities['insight']!,
    );
    final tal = _talents
        .map((t) => {'key': t['key'], 'value': t['value']})
        .toList();
    widget.onChanged(_valid, ab, tal);
  }

  void _changeAbility(String key, int delta) {
    final next = (_abilities[key]! + delta).clamp(0, 6);
    setState(() => _abilities[key] = next);
    _notify();
  }

  void _changeTalentValue(int idx, int delta) {
    final next = ((_talents[idx]['value'] as int) + delta).clamp(1, 4);
    setState(() => _talents[idx] = {..._talents[idx], 'value': next});
    _notify();
  }

  void _changeTalentKey(int idx, String key) {
    final talentKey = Talent.values.firstWhere((t) => t.name == key);
    setState(() => _talents[idx] = {..._talents[idx], 'key': talentKey});
    _notify();
  }

  void _addTalent() {
    if (_talents.length >= 5) return;
    final next = generalTalents.firstWhere(
      (k) => !_usedTalentKeys.contains(k.name),
    );

    setState(
      () => _talents = [
        ..._talents,
        {'key': next, 'value': 1},
      ],
    );
    _notify();
  }

  void _removeTalent(int idx) {
    if (_talents.length <= 2) return;
    setState(() {
      final list = [..._talents];
      list.removeAt(idx);
      _talents = list;
    });
    _notify();
  }

  @override
  void didUpdateWidget(_StatsStage old) {
    super.didUpdateWidget(old);
    if (old.usedSpecial != widget.usedSpecial) _notify();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final err = theme.colorScheme.error;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Abilities ──────────────────────────────────────────────────
          Text(
            'Capacidades',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Distribuye exactamente 15 puntos (0–6 por capacidad, '
            'máximo un 0 y un 6).',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ...List.generate(_abilityKeys.length, (i) {
            final key = _abilityKeys[i];
            final val = _abilities[key]!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: 120, child: Text(_abilityLabels[i])),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: val > 0 ? () => _changeAbility(key, -1) : null,
                    iconSize: 20,
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '$val',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: val < 6 ? () => _changeAbility(key, 1) : null,
                    iconSize: 20,
                  ),
                ],
              ),
            );
          }),
          Row(
            children: [
              Text(
                'Total: $_abilitySum / 15',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _abilityError != null ? err : Colors.grey,
                ),
              ),
            ],
          ),
          if (_abilityError != null) ...[
            const SizedBox(height: 4),
            Text(_abilityError!, style: TextStyle(color: err, fontSize: 12)),
          ],
          const SizedBox(height: 28),

          // ── Talents ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Talentos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$_talentTotal / $_talentBudget pts',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _talentError != null ? err : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Entre 2 y 5 talentos. Distribuye $_talentBudget puntos (1–4 por talento).',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          ...List.generate(_talents.length, (i) {
            final talent = _talents[i];
            final talKey = (talent['key'] as Talent).name;
            final talVal = talent['value'] as int;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: talKey,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: generalTalents
                            .where(
                              (e) =>
                                  e.name == talKey ||
                                  !_usedTalentKeys.contains(e.name),
                            )
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.name,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onChanged: (k) {
                          if (k != null) _changeTalentKey(i, k);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: talVal > 1
                          ? () => _changeTalentValue(i, -1)
                          : null,
                    ),
                    Text(
                      '$talVal',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: talVal < 4
                          ? () => _changeTalentValue(i, 1)
                          : null,
                    ),
                    if (_talents.length > 2)
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: err, size: 20),
                        onPressed: () => _removeTalent(i),
                      ),
                  ],
                ),
              ),
            );
          }),
          if (_talentError != null) ...[
            const SizedBox(height: 4),
            Text(_talentError!, style: TextStyle(color: err, fontSize: 12)),
          ],
          if (_talents.length < 5) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addTalent,
              icon: const Icon(Icons.add),
              label: const Text('Añadir talento'),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
