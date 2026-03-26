import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart' as fw;

/// 360° looping picker column using PageView
class _LoopingPicker extends StatefulWidget {
  final int maxValue;
  final int initialValue;
  final ValueChanged<int> onChanged;

  static const double itemHeight = 36.0;
  static const int visibleCount = 7;

  const _LoopingPicker({
    super.key,
    required this.maxValue,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_LoopingPicker> createState() => _LoopingPickerState();
}

class _LoopingPickerState extends State<_LoopingPicker> {
  late PageController _controller;
  int _currentValue = 0;
  static const int _loopMultiplier = 100; // large enough to feel infinite

  int get _itemCount => (widget.maxValue + 1) * (_loopMultiplier * 2 + 1);

  int _pageToValue(int page) {
    final int itemCount = widget.maxValue + 1;
    final int value = page % itemCount;
    return ((value % itemCount) + itemCount) % itemCount;
  }

  int _valueToPage(int value) {
    return value + _loopMultiplier * (widget.maxValue + 1);
  }

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    final startPage = _valueToPage(widget.initialValue);
    _controller = PageController(
      initialPage: startPage,
      viewportFraction: _LoopingPicker.itemHeight * _LoopingPicker.visibleCount / 400,
    );
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final page = _controller.page ?? _controller.page!.toDouble();
    final newValue = _pageToValue(page.round());
    if (newValue != _currentValue) {
      _currentValue = newValue;
      widget.onChanged(newValue);
    }
  }

  void jumpTo(int value) {
    if (_controller.hasClients) {
      _controller.jumpToPage(_valueToPage(value));
      _currentValue = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _LoopingPicker.itemHeight * _LoopingPicker.visibleCount,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: _itemCount,
            itemBuilder: (ctx, index) {
              final int itemCount = widget.maxValue + 1;
              final int value = index % itemCount;
              const int distFromCenter = 2;
              final double scale = 1.0 - (distFromCenter * 0.175);
              final double opacity = 1.0 - (distFromCenter * 0.22);
              final double fontSize = 90.0 * scale.clamp(0.0, 1.0);

              return Center(
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Text(
                    value.toString().padLeft(2, '0'),
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
            },
          ),
          // Selection band overlay
          Positioned(
            top: _LoopingPicker.itemHeight * 3,
            left: 4,
            right: 4,
            child: IgnorePointer(
              child: Container(
                height: _LoopingPicker.itemHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
  // Current selected values (tracked in state)
  late int _hours;
  late int _minutes;
  late int _seconds;

  // Keys to access _LoopingPicker state for external sync
  final _hoursKey = GlobalKey<_LoopingPickerState>();
  final _minutesKey = GlobalKey<_LoopingPickerState>();
  final _secondsKey = GlobalKey<_LoopingPickerState>();

  @override
  void initState() {
    super.initState();
    _hours = widget.initialHours;
    _minutes = widget.initialMinutes;
    _seconds = widget.initialSeconds;
  }

  @override
  void didUpdateWidget(TimerWheel old) {
    super.didUpdateWidget(old);
    // Sync when parent changes values externally (e.g. loading a preset)
    if (old.initialHours != widget.initialHours) {
      _hoursKey.currentState?.jumpTo(widget.initialHours);
    }
    if (old.initialMinutes != widget.initialMinutes) {
      _minutesKey.currentState?.jumpTo(widget.initialMinutes);
    }
    if (old.initialSeconds != widget.initialSeconds) {
      _secondsKey.currentState?.jumpTo(widget.initialSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Wheel row: 3 columns with hairline dividers, no colons
        SizedBox(
          height: _LoopingPicker.itemHeight * _LoopingPicker.visibleCount,
          child: Row(
            children: [
              // Hours column
              Expanded(
                child: _LoopingPicker(
                  key: _hoursKey,
                  maxValue: 23,
                  initialValue: _hours,
                  onChanged: (v) {
                    setState(() => _hours = v);
                    widget.onChanged(v, _minutes, _seconds);
                  },
                ),
              ),
              // Hairline divider 1
              Container(width: 0.5, color: const Color(0xFF38383A)),
              // Minutes column
              Expanded(
                child: _LoopingPicker(
                  key: _minutesKey,
                  maxValue: 59,
                  initialValue: _minutes,
                  onChanged: (v) {
                    setState(() => _minutes = v);
                    widget.onChanged(_hours, v, _seconds);
                  },
                ),
              ),
              // Hairline divider 2
              Container(width: 0.5, color: const Color(0xFF38383A)),
              // Seconds column
              Expanded(
                child: _LoopingPicker(
                  key: _secondsKey,
                  maxValue: 59,
                  initialValue: _seconds,
                  onChanged: (v) {
                    setState(() => _seconds = v);
                    widget.onChanged(_hours, _minutes, v);
                  },
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

  int _getHours() => _hours;
  int _getMinutes() => _minutes;
  int _getSeconds() => _seconds;
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
