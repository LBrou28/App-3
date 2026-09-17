import 'package:flutter/material.dart';

import '../app_state.dart';
import '../catalog.dart';
import '../models.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});
  @override
  Widget build(BuildContext c) {
    final s = ReelScope.of(c);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Header(
          'THREE TASTES. ONE MOVIE.',
          'Meet the movie crew',
          'Choose genres and a maximum runtime for each viewer.',
        ),
        ...List.generate(3, (i) => ViewerCard(index: i, viewer: s.viewers[i])),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header(this.eyebrow, this.title, this.subtitle, {super.key});
  final String eyebrow, title, subtitle;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: Color(0xffacc28e),
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: Theme.of(c).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xffa0afa4), height: 1.4),
        ),
      ],
    ),
  );
}

class ViewerCard extends StatefulWidget {
  const ViewerCard({required this.index, required this.viewer, super.key});
  final int index;
  final Viewer viewer;
  @override
  State<ViewerCard> createState() => _ViewerCardState();
}

class _ViewerCardState extends State<ViewerCard> {
  late final TextEditingController name;
  late Set<String> selected;
  late int runtime;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.viewer.name);
    selected = {...widget.viewer.genres};
    runtime = widget.viewer.maxMinutes;
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  void save() {
    final value = name.text.trim();
    if (value.isEmpty || selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a name and choose at least one genre.'),
        ),
      );
      return;
    }
    ReelScope.of(context).updateViewer(
      widget.index,
      Viewer(name: value, genres: selected, maxMinutes: runtime),
    );
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$value’s tastes were saved.')));
  }

  @override
  Widget build(BuildContext c) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xffcdeb8b),
                foregroundColor: const Color(0xff253019),
                child: Text((widget.index + 1).toString()),
              ),
              const SizedBox(width: 12),
              Text(
                'VIEWER 0${widget.index + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.6,
                  color: Color(0xffacc28e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: name,
            maxLength: 30,
            decoration: const InputDecoration(
              labelText: 'Name',
              counterText: '',
            ),
          ),
          const SizedBox(height: 12),
          const Text('Favorite genres'),
          Wrap(
            spacing: 7,
            children: genres
                .map(
                  (g) => FilterChip(
                    label: Text(g),
                    selected: selected.contains(g),
                    onSelected: (v) => setState(
                      () => v ? selected.add(g) : selected.remove(g),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: runtime,
            decoration: const InputDecoration(labelText: 'Maximum runtime'),
            items: [110, 130, 150, 180]
                .map(
                  (n) => DropdownMenuItem(value: n, child: Text('$n minutes')),
                )
                .toList(),
            onChanged: (v) => setState(() => runtime = v ?? runtime),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: save,
              child: const Text('Save tastes'),
            ),
          ),
        ],
      ),
    ),
  );
}
