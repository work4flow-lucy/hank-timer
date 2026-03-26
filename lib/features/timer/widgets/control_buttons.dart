import 'package:flutter/material.dart';
import '../providers/timer_provider.dart';

class ControlButtons extends StatelessWidget {
  final bool isRunning;
  final TimerStatus status;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onPause;
  final VoidCallback onResume;

  const ControlButtons({
    super.key,
    required this.isRunning,
    required this.status,
    required this.onStart,
    required this.onCancel,
    required this.onPause,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    if (status == TimerStatus.completed) {
      return _buildDoneButton();
    }
    if (isRunning) {
      return _buildRunningButtons();
    }
    if (status == TimerStatus.paused) {
      return _buildPausedButtons();
    }
    return _buildStartButton();
  }

  Widget _buildStartButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onStart,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF30D158),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              'Start',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRunningButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: GestureDetector(
              onTap: onCancel,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF453A),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Pause button
          Expanded(
            child: GestureDetector(
              onTap: onPause,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9F0A),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Pause',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPausedButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: GestureDetector(
              onTap: onCancel,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF453A),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Resume button
          Expanded(
            child: GestureDetector(
              onTap: onResume,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF30D158),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    'Resume',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF30D158),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
