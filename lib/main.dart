import 'package:flutter/material.dart';

import 'app_state.dart';
import 'features/preferences.dart';
import 'features/discover.dart';
import 'features/voting.dart';

void main() => runApp(const ReelMatchApp());

class ReelMatchApp extends StatefulWidget {
  const ReelMatchApp({super.key});
  @override
  State<ReelMatchApp> createState() => _ReelMatchAppState();
}

class _ReelMatchAppState extends State<ReelMatchApp> {
  final state = AppState();
  int page = 0;
  @override
  void initState() {
    super.initState();
    state.addListener(refresh);
    state.load();
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    state.removeListener(refresh);
    state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pages = [PreferencesScreen(), DiscoverScreen(), VotingScreen()];
    return MaterialApp(
      title: 'ReelMatch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xff141817),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffcdeb8b),
          brightness: Brightness.dark,
          surface: const Color(0xff202820),
        ),
        cardTheme: const CardThemeData(color: Color(0xff202820)),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xff181e19),
          border: OutlineInputBorder(),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'reel',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: 'match',
                  style: TextStyle(
                    color: Color(0xffcdeb8b),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: ReelScope(
            state: state,
            child: IndexedStack(index: page, children: pages),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: page,
          onDestinationSelected: (value) => setState(() => page = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.tune), label: 'Tastes'),
            NavigationDestination(
              icon: Icon(Icons.movie_filter_outlined),
              label: 'Discover',
            ),
            NavigationDestination(
              icon: Icon(Icons.how_to_vote_outlined),
              label: 'Vote',
            ),
          ],
        ),
      ),
    );
  }
}
