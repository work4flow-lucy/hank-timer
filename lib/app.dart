import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold;
import 'features/timer/screens/timer_screen.dart';

class HankTimerApp extends StatelessWidget {
  const HankTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Hank Timer',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0A84FF),
        scaffoldBackgroundColor: Color(0xFF000000),
      ),
      home: MainTabView(),
    );
  }
}

class MainTabView extends StatelessWidget {
  const MainTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: const Color(0xFF1C1C1E),
        activeColor: const Color(0xFF0A84FF),
        inactiveColor: const Color(0xFF8E8E93),
        border: const Border(
          top: BorderSide(
            color: Color(0xFF3A3A3C),
            width: 0.5,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.speedometer),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.moon_fill),
            label: 'Bedtime',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const TimerScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const _PlaceholderScreen(
                title: 'Alarm',
                icon: CupertinoIcons.bell,
              ),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const _PlaceholderScreen(
                title: 'Stopwatch',
                icon: CupertinoIcons.speedometer,
              ),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => const _PlaceholderScreen(
                title: 'Bedtime',
                icon: CupertinoIcons.moon_fill,
              ),
            );
          default:
            return CupertinoTabView(
              builder: (context) => const TimerScreen(),
            );
        }
      },
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: const Color(0xFF8E8E93),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Coming soon',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8E8E93),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
