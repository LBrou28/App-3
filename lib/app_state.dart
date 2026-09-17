import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'catalog.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  static const key = 'reelmatch_state_v1';
  List<Viewer> viewers = [
    Viewer(name: 'Alex', genres: {'Sci-Fi', 'Adventure'}, maxMinutes: 150),
    Viewer(name: 'Jordan', genres: {'Comedy', 'Mystery'}, maxMinutes: 150),
    Viewer(name: 'Sam', genres: {'Animation', 'Adventure'}, maxMinutes: 150),
  ];
  final Set<String> shortlist = {};
  List<String?> votes = [null, null, null];
  Future<void> load() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(key);
      if (raw != null) {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final people = (data['viewers'] as List)
            .map((x) => Viewer.fromJson(Map<String, dynamic>.from(x as Map)))
            .toList();
        if (people.length == 3) viewers = people;
        shortlist.addAll(
          (data['shortlist'] as List).cast<String>().where(
            (id) => movieById(id) != null,
          ),
        );
        final saved = (data['votes'] as List).map((x) => x as String?).toList();
        if (saved.length == 3) {
          votes = saved.map((x) => shortlist.contains(x) ? x : null).toList();
        }
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        key,
        jsonEncode({
          'viewers': viewers.map((x) => x.toJson()).toList(),
          'shortlist': shortlist.toList(),
          'votes': votes,
        }),
      );
    } catch (_) {}
  }

  void updateViewer(int i, Viewer viewer) {
    viewers[i] = viewer;
    notifyListeners();
    save();
  }

  void toggleShortlist(String id) {
    if (!shortlist.add(id)) {
      shortlist.remove(id);
      votes = votes.map((x) => x == id ? null : x).toList();
    }
    notifyListeners();
    save();
  }

  void castVote(int i, String? id) {
    votes[i] = shortlist.contains(id) ? id : null;
    notifyListeners();
    save();
  }

  Movie? movieById(String id) {
    for (final movie in movies) {
      if (movie.id == id) return movie;
    }
    return null;
  }

  List<MovieMatch> rankedMovies() {
    final result = movies.map((movie) {
      final scores = viewers
          .map(
            (viewer) =>
                (movie.genres.where(viewer.genres.contains).length /
                        movie.genres.length *
                        100)
                    .round(),
          )
          .toList();
      return MovieMatch(
        movie: movie,
        scores: scores,
        groupScore: (scores.reduce((a, b) => a + b) / 3).round(),
        fitsEveryone: viewers.every(
          (viewer) => movie.minutes <= viewer.maxMinutes,
        ),
      );
    }).toList();
    result.sort((a, b) {
      final fit = (b.fitsEveryone ? 1 : 0).compareTo(a.fitsEveryone ? 1 : 0);
      if (fit != 0) return fit;
      final score = b.groupScore.compareTo(a.groupScore);
      return score != 0 ? score : a.movie.title.compareTo(b.movie.title);
    });
    return result;
  }
}

class ReelScope extends InheritedWidget {
  const ReelScope({required this.state, required super.child, super.key});
  final AppState state;
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ReelScope>()!.state;
  @override
  bool updateShouldNotify(ReelScope oldWidget) => true;
}
