import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_wheel.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(
          children: [
            // ── Nav Bar ───────────────────────────────
            _buildNavBar(),

            // ── Main Scrollable Content ───────────────
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<TimerProvider>(
                  builder: (context, timer, _) {
                    return Column(
                      children: [
                        // ── Large Display ─────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildLargeDisplay(timer),
                        ),

                        const SizedBox(height: 20),

                        // ── Wheel Picker ────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TimerWheel(
                              initialHours: timer.hours,
                              initialMinutes: timer.minutes,
                              initialSeconds: timer.seconds,
                              onChanged: (h, m, s) {
                                timer.setWheelValues(h, m, s);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Circular Buttons ─────────────
                        _buildCircularButtons(timer),

                        const SizedBox(height: 20),

                        // ── Settings Card ─────────────────
                        _buildSettingsCard(timer),

                        const SizedBox(height: 20),

                        // ── Recents Section ───────────────
                        _buildRecentsSection(timer),

                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ── Tab Bar ───────────────────────────────
            _buildTabBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            onPressed: () {},
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFFFF9500),
              ),
            ),
          ),
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.timer,
                  color: CupertinoColors.white,
                  size: 22,
                ),
                SizedBox(width: 6),
                Text(
                  'Timers',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.plus,
              color: CupertinoColors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeDisplay(TimerProvider timer) {
    String mainNum;
    String unit;

    if (timer.isRunning || timer.isPaused) {
      if (timer.hours > 0) {
        mainNum = '${timer.hours}:${timer.minutes.toString().padLeft(2, '0')}:${timer.seconds.toString().padLeft(2, '0')}';
        unit = '';
      } else {
        mainNum = '${timer.minutes}:${timer.seconds.toString().padLeft(2, '0')}';
        unit = '';
      }
    } else if (timer.status.name == 'completed') {
      mainNum = "Time's";
      unit = 'up';
    } else {
      if (timer.hours > 0) {
        mainNum = '${timer.hours}:${timer.minutes.toString().padLeft(2, '0')}';
        unit = '';
      } else {
        mainNum = '${timer.minutes}';
        unit = 'min';
      }
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              mainNum,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 94,
                fontWeight: FontWeight.w300,
                color: CupertinoColors.white,
                fontFeatures: [FontFeature.tabularFigures()],
                letterSpacing: -4,
                height: 1,
              ),
            ),
          ),
          if (unit.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              unit,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: Color(0xFF8E8E93),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCircularButtons(TimerProvider timer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel — gray circle with xmark
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF8E8E93),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.xmark,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          ),

          // Start — green circle with play
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              timer.start();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF34C759),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.play_fill,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(TimerProvider timer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _SettingsRow(
            label: 'When Timer Ends',
            value: timer.sound,
            showChevron: true,
            onTap: () => _showSoundPicker(timer),
            showDivider: true,
          ),
          _SettingsRow(
            label: 'Label',
            value: timer.label,
            showChevron: true,
            onTap: () => _showLabelPicker(timer),
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentsSection(TimerProvider timer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recent title
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E93),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Recents card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (int i = 0; i < timer.recents.length; i++) ...[
                _RecentRow(
                  label: timer.recents[i].label,
                  duration: _formatDuration(timer.recents[i].duration),
                  onTap: () => timer.loadFromRecent(timer.recents[i]),
                ),
                if (i < timer.recents.length - 1)
                  Container(
                    margin: const EdgeInsets.only(left: 54),
                    height: 0.5,
                    color: const Color(0xFF38383A),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes % 60}m';
    }
    return '${d.inMinutes}m';
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TabItem(
                icon: CupertinoIcons.globe,
                label: 'World Clock',
                isActive: false,
                onTap: () {},
              ),
              _TabItem(
                icon: CupertinoIcons.bell,
                label: 'Alarms',
                isActive: false,
                onTap: () {},
              ),
              _TabItem(
                icon: CupertinoIcons.speedometer,
                label: 'Stopwatch',
                isActive: false,
                onTap: () {},
              ),
              _TabItem(
                icon: CupertinoIcons.timer,
                label: 'Timers',
                isActive: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSoundPicker(TimerProvider timer) {
    showCupertinoModalPopup(
      context: navigatorKey.currentContext!,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('When Timer Ends'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              timer.setSound('Alarm');
              Navigator.pop(ctx);
            },
            child: const Text('Alarm'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              timer.setSound('Radar');
              Navigator.pop(ctx);
            },
            child: const Text('Radar'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              timer.setSound('Riptide');
              Navigator.pop(ctx);
            },
            child: const Text('Riptide'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showLabelPicker(TimerProvider timer) {
    showCupertinoModalPopup(
      context: navigatorKey.currentContext!,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Label'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              timer.setLabel('Timer');
              Navigator.pop(ctx);
            },
            child: const Text('Timer'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              timer.setLabel('Nap');
              Navigator.pop(ctx);
            },
            child: const Text('Nap'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              timer.setLabel('Break');
              Navigator.pop(ctx);
            },
            child: const Text('Break'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showChevron;
  final VoidCallback? onTap;
  final bool showDivider;

  const _SettingsRow({
    required this.label,
    required this.value,
    this.showChevron = false,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 17,
                    color: CupertinoColors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                if (showChevron) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 18,
                    color: Color(0xFF48484A),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 16),
            height: 0.5,
            color: const Color(0xFF38383A),
          ),
      ],
    );
  }
}

class _RecentRow extends StatelessWidget {
  final String label;
  final String duration;
  final VoidCallback onTap;

  const _RecentRow({
    required this.label,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Play button (28px green circle)
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF34C759),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.play_fill,
                color: CupertinoColors.white,
                size: 12,
              ),
            ),
            const SizedBox(width: 12),
            // Label
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              duration,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF8E8E93),
              ),
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: Color(0xFF48484A),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Orange dot indicator above icon
          if (isActive)
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                color: Color(0xFFFF9500),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 10),
          Icon(
            icon,
            size: 24,
            color: isActive
                ? CupertinoColors.white
                : const Color(0xFF8E8E93),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? CupertinoColors.white
                  : const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }
}

// Global navigator key for modal popups
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
