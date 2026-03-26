import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/timer/providers/timer_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TimerProvider(),
      child: const HankTimerApp(),
    ),
  );
}
