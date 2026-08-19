import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int timeLeft;
  final bool isTimerRunning;
  final bool isExamFinished;

  const TimerWidget({
    super.key,
    required this.timeLeft,
    required this.isTimerRunning,
    required this.isExamFinished,
  });

  @override
  Widget build(BuildContext context) {
    if (isExamFinished) return const SizedBox.shrink();

    final minutes = timeLeft ~/ 60;
    final seconds = timeLeft % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    Color timerColor = Colors.green;
    if (timeLeft <= 300) {
      timerColor = Colors.red;
    } else if (timeLeft <= 600) {
      timerColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: timerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: timerColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 18,
            color: timerColor,
          ),
          const SizedBox(width: 6),
          Text(
            timeString,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }
}
