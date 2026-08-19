import 'package:flutter/material.dart';
import '../models/exam_model.dart';
import 'exam_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ExamData examData;

  @override
  void initState() {
    super.initState();
    examData = ExamData();
    examData.initializeQuestions();
    _startTimer();
  }

  void _startTimer() {
    examData.isTimerRunning = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!examData.isTimerRunning || examData.isExamFinished) return false;
      examData.timeLeft--;
      if (mounted) setState(() {});
      if (examData.timeLeft <= 0) {
        examData.isTimerRunning = false;
        examData.isTimeout = true;
        if (!examData.isExamFinished) {
          _forceFinishAllSections();
        }
        return false;
      }
      return true;
    });
  }

  void _forceFinishAllSections() {
    for (int s = 1; s <= 4; s++) {
      final sectionQuestions = examData.getQuestionsForSection(s);
      for (final q in sectionQuestions) {
        if (q.selectedIndex == null) {
          final index = examData.questions.indexOf(q);
          if (index != -1) {
            examData.questions[index] = q.copyWith(
              selectedIndex: 0,
            );
          }
        }
      }
      int correct = 0;
      for (final q in sectionQuestions) {
        if (q.selectedIndex == q.correctIndex) {
          correct++;
        }
      }
      final percent = (correct / sectionQuestions.length) * 100;
      final sectionNames = {
        1: 'Script and Vocabulary',
        2: 'Conversation and Expression',
        3: 'Listening Comprehension',
        4: 'Reading Comprehension',
      };
      examData.sectionResults.add(
        SectionResult(
          sectionNumber: s,
          name: sectionNames[s] ?? 'Section $s',
          score: percent,
          correctCount: correct,
          totalCount: sectionQuestions.length,
        ),
      );
    }
    examData.isExamFinished = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final timeString = _formatTime(examData.timeLeft);

    return Scaffold(
      appBar: AppBar(
        title: const Text('JFT Exam Practice'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              timeString,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.school, size: 64, color: Colors.blue),
                  const SizedBox(height: 12),
                  const Text(
                    'JFT Simulation Exam',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Practice for your Japanese Language Proficiency Test',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '📚 Study Materials',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStudyCard(
                    icon: Icons.font_download,
                    label: 'Vocabulary',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStudyCard(
                    icon: Icons.translate,
                    label: 'Kanji',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStudyCard(
                    icon: Icons.spellcheck,
                    label: 'Grammar',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStudyCard(
                    icon: Icons.chat,
                    label: 'Conversation',
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '📝 Practice Exams',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final exams = ['JFT-1', 'JFT-2', 'JFT-3', 'JFT-4', 'JFT-5', 'JFT-6'];
                return _buildExamButton(
                  label: exams[index],
                  onTap: () {
                    if (exams[index] == 'JFT-1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExamScreen(
                            examData: examData,
                            onUpdate: () {
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${exams[index]} is coming soon!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About JFT Exam',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The JFT (Japanese Language Test) is designed to measure '
                    'the Japanese language proficiency of non-native speakers.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildContactItem(Icons.email, 'ayezarmoe2003@gmail.com'),
                  _buildContactItem(Icons.phone, '+959773883159'),
                  _buildContactItem(Icons.telegram, '@shinegyi123'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Created By Shine | JFT Exam Preparation',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildStudyCard({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blue, Color(0xFF1565C0)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.file_copy, size: 28, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}