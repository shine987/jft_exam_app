import 'package:flutter/material.dart';
import '../models/exam_model.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Function(int) onOptionSelected;
  final VoidCallback onNext;
  final bool showNextButton;
  final bool isReviewMode;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onOptionSelected,
    required this.onNext,
    required this.showNextButton,
    required this.isReviewMode,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = question.selectedIndex;
    final correctIndex = question.correctIndex;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Question ${question.id}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isReviewMode)
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'REVIEW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.questionText,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              question.options.length,
              (index) => _buildOption(
                index,
                question.options[index],
                selectedIndex,
                correctIndex,
              ),
            ),
            const SizedBox(height: 20),
            if (showNextButton && !isReviewMode)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: selectedIndex != null ? onNext : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            if (isReviewMode)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: selectedIndex == correctIndex
                      ? Colors.green.shade50
                      : selectedIndex != null
                          ? Colors.red.shade50
                          : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selectedIndex == correctIndex
                        ? Colors.green.shade300
                        : selectedIndex != null
                            ? Colors.red.shade300
                            : Colors.orange.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedIndex == correctIndex
                          ? Icons.check_circle
                          : selectedIndex != null
                              ? Icons.cancel
                              : Icons.warning,
                      color: selectedIndex == correctIndex
                          ? Colors.green.shade700
                          : selectedIndex != null
                              ? Colors.red.shade700
                              : Colors.orange.shade700,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedIndex == correctIndex
                            ? '✅ Correct answer!'
                            : selectedIndex != null
                                ? '❌ Wrong answer'
                                : '⚠️ Not answered',
                        style: TextStyle(
                          color: selectedIndex == correctIndex
                              ? Colors.green.shade700
                              : selectedIndex != null
                                  ? Colors.red.shade700
                                  : Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    int index,
    String text,
    int? selectedIndex,
    int correctIndex,
  ) {
    bool isSelected = selectedIndex == index;
    bool isCorrect = index == correctIndex;

    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;
    Color circleColor = Colors.grey.shade300;
    Color circleTextColor = Colors.grey.shade600;

    if (isReviewMode) {
      if (isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        circleColor = Colors.green;
        circleTextColor = Colors.white;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        circleColor = Colors.red;
        circleTextColor = Colors.white;
      }
    } else {
      if (isSelected) {
        borderColor = Colors.blue;
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        circleColor = Colors.blue;
        circleTextColor = Colors.white;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (!isReviewMode && selectedIndex == null) {
            onOptionSelected(index);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: bgColor,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: TextStyle(
                      color: circleTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isReviewMode && isCorrect)
                const Icon(Icons.check_circle, color: Colors.green, size: 22),
              if (isReviewMode && isSelected && !isCorrect)
                const Icon(Icons.cancel, color: Colors.red, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
