import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Function(int) onQuestionSelected;
  final bool isReviewMode;

  const NavigationWidget({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.onQuestionSelected,
    this.isReviewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: totalQuestions,
        itemBuilder: (context, index) {
          final isActive = index == currentIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              onTap: () => onQuestionSelected(index),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive 
                      ? (isReviewMode ? Colors.purple : Colors.blue)
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}