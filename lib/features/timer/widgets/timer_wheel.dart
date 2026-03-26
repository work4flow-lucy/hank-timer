import 'package:flutter/cupertino.dart';

class TimerWheel extends StatefulWidget {
  final int initialHours;
  final int initialMinutes;
  final int initialSeconds;
  final Function(int hours, int minutes, int seconds) onChanged;

  const TimerWheel({
    super.key,
    this.initialHours = 0,
    this.initialMinutes = 5,
    this.initialSeconds = 0,
    required this.onChanged,
  });

  @override
  State<TimerWheel> createState() => _TimerWheelState();
}

class _TimerWheelState extends State<TimerWheel> {
  late FixedExtentScrollController _hoursController;
  late FixedExtentScrollController _minutesController;
  late FixedExtentScrollController _secondsController;

  static const double _itemHeight = 50.0;  // iOS picker item height
  static const int _visibleCount = 5;
  static const int _padding = 2;           // blank items at top/bottom

  @override
  void initState() {
    super.initState();
    _hoursController = FixedExtentScrollController(
      initialItem: widget.initialHours + _padding,
    );
    _minutesController = FixedExtentScrollController(
      initialItem: widget.initialMinutes + _padding,
    );
    _secondsController = FixedExtentScrollController(
      initialItem: widget.initialSeconds + _padding,
    );
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Wheel row: 3 columns with hairline dividers, no colons
        SizedBox(
          height: _itemHeight * _visibleCount,
          child: Row(
            children: [
              // Hours column
              Expanded(
                child: _buildPickerColumn(
                  controller: _hoursController,
                  maxValue: 23,
                  onChanged: (v) => widget.onChanged(v, _getMinutes(), _getSeconds()),
                ),
              ),
              // Hairline divider 1
              Container(width: 0.5, color: const Color(0xFF38383A)),
              // Minutes column
              Expanded(
                child: _buildPickerColumn(
                  controller: _minutesController,
                  maxValue: 59,
                  onChanged: (v) => widget.onChanged(_getHours(), v, _getSeconds()),
                ),
              ),
              // Hairline divider 2
              Container(width: 0.5, color: const Color(0xFF38383A)),
              // Seconds column
              Expanded(
                child: _buildPickerColumn(
                  controller: _secondsController,
                  maxValue: 59,
                  onChanged: (v) => widget.onChanged(_getHours(), _getMinutes(), v),
                ),
              ),
            ],
          ),
        ),
        // Unit labels row: hrs | min | sec
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Expanded(child: _UnitLabel(text: 'hrs')),
              Container(width: 0.5, color: const Color(0x00000000)), // spacer
              const Expanded(child: _UnitLabel(text: 'min')),
              Container(width: 0.5, color: const Color(0x00000000)), // spacer
              const Expanded(child: _UnitLabel(text: 'sec')),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  int _getHours() => (_hoursController.selectedItem - _padding).clamp(0, 23);
  int _getMinutes() => (_minutesController.selectedItem - _padding).clamp(0, 59);
  int _getSeconds() => (_secondsController.selectedItem - _padding).clamp(0, 59);

  Widget _buildPickerColumn({
    required FixedExtentScrollController controller,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    final totalItems = maxValue + 1 + _padding * 2;

    return Stack(
      alignment: Alignment.center,
      children: [
        // iOS-style picker with iOS 94pt-style center item
        CupertinoPicker(
          scrollController: controller,
          itemExtent: _itemHeight,
          selectionOverlay: const SizedBox.shrink(),
          onSelectedItemChanged: (index) {
            final value = index - _padding;
            if (value >= 0 && value <= maxValue) {
              onChanged(value);
            }
          },
          children: List.generate(totalItems, (index) {
            final value = index - _padding;
            if (value < 0 || value > maxValue) {
              return SizedBox(height: _itemHeight);
            }
            // Distance from center (center = index 2 in 5-item window)
            final distFromCenter = (index - 2).abs();
            // Scale: center=1.0, outer items smaller (~65% for extreme)
            final scale = 1.0 - (distFromCenter * 0.175);
            // Opacity: center=1.0, outer items fade
            final opacity = 1.0 - (distFromCenter * 0.22);
            // Font size: center=90pt (matches iOS spec 94pt), outer items scale down
            final fontSize = 90.0 * scale.clamp(0.0, 1.0);

            return Center(
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Text(
                  value.toString(), // No leading zero — matches iOS spec
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w300,
                    color: CupertinoColors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    letterSpacing: -4,
                    height: 1,
                  ),
                ),
              ),
            );
          }),
        ),

        // Selection band overlay (subtle)
        Positioned(
          top: _itemHeight * 2,
          left: 0,
          right: 0,
          child: Container(
            height: _itemHeight,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _UnitLabel extends StatelessWidget {
  final String text;

  const _UnitLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8E8E93),
      ),
    );
  }
}
