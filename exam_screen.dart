import 'package:flutter/material.dart';
import '../models/exam_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/timer_widget.dart';
import '../widgets/navigation_widget.dart';
import '../widgets/result_widget.dart';

class ExamScreen extends StatefulWidget {
  final ExamData examData;
  final VoidCallback onUpdate;

  const ExamScreen({
    super.key,
    required this.examData,
    required this.onUpdate,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  @override
  Widget build(BuildContext context) {
    final examData = widget.examData;

    if (examData.isExamFinished) {
      return ResultWidget(
        examData: examData,
        onReview: () {
          examData.isReviewMode = true;
          examData.currentSection = 1;
          examData.currentQuestionIndex = 0;
          setState(() {});
        },
        onRetry: () {
          examData.resetExam();
          setState(() {});
        },
        onBackToHome: () {
          Navigator.pop(context);
          widget.onUpdate();
        },
      );
    }

    final sectionQuestions = examData.getQuestionsForSection(
      examData.currentSection,
    );
    
    if (sectionQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available')),
      );
    }

    final currentQuestion = examData.getCurrentQuestion();
    final totalQuestions = sectionQuestions.length;
    final isAllAnswered = examData.isAllQuestionsAnswered(
      examData.currentSection,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          examData.isReviewMode 
              ? 'Review - Section ${examData.currentSection}'
              : 'Section ${examData.currentSection}',
        ),
        backgroundColor: examData.isReviewMode ? Colors.purple : Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (examData.isReviewMode) {
              examData.isReviewMode = false;
              setState(() {});
            } else {
              Navigator.pop(context);
              widget.onUpdate();
            }
          },
        ),
        actions: [
          if (!examData.isReviewMode)
            TimerWidget(
              timeLeft: examData.timeLeft,
              isTimerRunning: examData.isTimerRunning,
              isExamFinished: examData.isExamFinished,
            ),
        ],
      ),
      body: Column(
        children: [
          NavigationWidget(
            totalQuestions: totalQuestions,
            currentIndex: examData.currentQuestionIndex,
            onQuestionSelected: (index) {
              examData.currentQuestionIndex = index;
              setState(() {});
            },
            isReviewMode: examData.isReviewMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: QuestionWidget(
                question: currentQuestion,
                onOptionSelected: (index) {
                  if (!examData.isReviewMode) {
                    final sectionQs = examData.getQuestionsForSection(examData.currentSection);
                    final q = sectionQs[examData.currentQuestionIndex];
                    final idx = examData.questions.indexOf(q);
                    if (idx != -1) {
                      examData.questions[idx] = q.copyWith(
                        selectedIndex: index,
                      );
                      setState(() {});
                    }
                  }
                },
                onNext: () {
                  if (!examData.isReviewMode) {
                    final sectionQs = examData.getQuestionsForSection(examData.currentSection);
                    if (examData.currentQuestionIndex < sectionQs.length - 1) {
                      examData.currentQuestionIndex++;
                      setState(() {});
                    }
                  }
                },
                showNextButton: examData.currentQuestionIndex < totalQuestions - 1,
                isReviewMode: examData.isReviewMode,
              ),
            ),
          ),
          if (!examData.isReviewMode)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAllAnswered
                      ? () => _finishSection(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: Text(
                    'Finish Section ${examData.currentSection}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          if (!examData.isReviewMode && !isAllAnswered)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please complete all questions before finishing.',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (examData.isReviewMode)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    examData.isReviewMode = false;
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back to Results',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _finishSection(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Section?'),
        content: const Text('Are you sure you want to finish this section?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.examData.finishSection(widget.examData.currentSection);
              setState(() {});
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}