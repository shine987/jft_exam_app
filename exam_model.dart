import 'package:flutter/material.dart';

class Question {
  final int id;
  final int section;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  int? selectedIndex;

  Question({
    required this.id,
    required this.section,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    this.selectedIndex,
  });

  Question copyWith({
    int? id,
    int? section,
    String? questionText,
    List<String>? options,
    int? correctIndex,
    int? selectedIndex,
  }) {
    return Question(
      id: id ?? this.id,
      section: section ?? this.section,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class SectionResult {
  final int sectionNumber;
  final String name;
  final double score;
  final int correctCount;
  final int totalCount;

  SectionResult({
    required this.sectionNumber,
    required this.name,
    required this.score,
    required this.correctCount,
    required this.totalCount,
  });
}

class ExamData {
  List<Question> questions = [];
  int currentSection = 1;
  int currentQuestionIndex = 0;
  bool isExamFinished = false;
  bool isReviewMode = false;
  List<SectionResult> sectionResults = [];
  int timeLeft = 3600;
  bool isTimerRunning = false;
  bool isTimeout = false;

  void initializeQuestions() {
    final section1Questions = [
      Question(
        id: 1,
        section: 1,
        questionText: '毎朝、花に水を(______)います。',
        options: ['入れて', 'やって', '入って'],
        correctIndex: 1,
      ),
      Question(
        id: 2,
        section: 1,
        questionText: 'このごろはお金 (_______) 大変です。',
        options: ['ないで', 'なくて', 'なくても'],
        correctIndex: 1,
      ),
      Question(
        id: 3,
        section: 1,
        questionText: 'この肉は(________), いいです。',
        options: ['ひろくて', 'かたい', 'やわらかくて'],
        correctIndex: 2,
      ),
      Question(
        id: 4,
        section: 1,
        questionText: '大きな声で呼んだのに (返事) がありません。',
        options: ['しごと', 'べんじ', 'へんじ'],
        correctIndex: 2,
      ),
      Question(
        id: 5,
        section: 1,
        questionText: 'ここは木が倒れているので (通れません)。',
        options: ['とおれません', 'とうれません', 'どうれません'],
        correctIndex: 0,
      ),
      Question(
        id: 6,
        section: 1,
        questionText: '早くひらがなが(________ ) 練習をしています。',
        options: ['読めるように', '読める', '読めるために'],
        correctIndex: 0,
      ),
      Question(
        id: 7,
        section: 1,
        questionText: '夜、バスがなくて、友達のうちに (_______)ことがあります。',
        options: ['止まった', '泊まった', '入った'],
        correctIndex: 1,
      ),
      Question(
        id: 8,
        section: 1,
        questionText: 'この漢字の読み方は何ですか。 (勉強)',
        options: ['べんきょう', 'べんきょ', 'へんきょう'],
        correctIndex: 0,
      ),
      Question(
        id: 9,
        section: 1,
        questionText: 'この漢字の読み方は何ですか。 (食事)',
        options: ['しょくじ', 'しょくし', 'しょくじゅ'],
        correctIndex: 0,
      ),
      Question(
        id: 10,
        section: 1,
        questionText: 'この漢字の読み方は何ですか。 (電話)',
        options: ['でんわ', 'でんば', 'てんわ'],
        correctIndex: 0,
      ),
    ];

    final section2Questions = [
      Question(
        id: 11,
        section: 2,
        questionText:
            'ジョイ: 日本の人はどうやって食事をしますか。\n\n田中: はしと茶わんで食事をします。\n\nジョイ: 茶わんは手で(__________)。\n\n田中: はい、手で持ちます。',
        options: ['まちます', 'もちます', 'めします'],
        correctIndex: 1,
      ),
      Question(
        id: 12,
        section: 2,
        questionText:
            'きゃく: すみません、メコンのカメラはあります。\n\n店員: はい、こちらです。\n\nきゃく: (_____________)\n\n店員: これは五万六千円です。',
        options: ['いくらになりますか', 'いつになりますか', 'いくつになりますか'],
        correctIndex: 0,
      ),
      Question(
        id: 13,
        section: 2,
        questionText:
            'リン: パクさんはお酒をよく飲みますか。\n\nパク: 私はお酒があまり好きではありませんが、ときどき飲みますよ。\n\nリン: 私の家族は、みんなお酒が好きですから、たくさん飲みます。でも、わたしはぜんぜん(________________)',
        options: ['のみました', 'のみません', 'のみます'],
        correctIndex: 1,
      ),
      Question(
        id: 14,
        section: 2,
        questionText:
            'A: すみません。田中課長いらっしゃいますか。\n\nB: はい、おります。少々(______________)',
        options: ['持つください', 'お持ちください', 'お待ちください'],
        correctIndex: 2,
      ),
      Question(
        id: 15,
        section: 2,
        questionText:
            'A: (____________)。具合が悪いそうですね。\n\nB: ええ、ちょっと頭がいたくて。\n\nA: 大丈夫ですか。\n\nB: すみませんが、休んでもいいですか。',
        options: ['こんにちは', 'どうしたんですか', 'はい'],
        correctIndex: 1,
      ),
      Question(
        id: 16,
        section: 2,
        questionText:
            'A: 何がいいですか。\n\nB: ジュースがいいです。\n\nA: すみません。ジュースとコーラをお願いします。\n\nB: はい、ジュースとコーラですね。(____________).',
        options: ['どうぞよろしく', 'かしこまりました', 'はい、そうします'],
        correctIndex: 1,
      ),
      Question(
        id: 17,
        section: 2,
        questionText:
            'A: 好きな季節はいつですか。\n\nB: 秋が一番好きです。\n\nA: (___________________).\n\nB: 食べ物がおいしいですから。',
        options: ['どうしたんですか', 'どうしてですか', 'どれですか'],
        correctIndex: 1,
      ),
      Question(
        id: 18,
        section: 2,
        questionText:
            'A: もしもし、ジョイさんですか。田中です。\n\nB: お久しぶりです。田中さん、お元気ですか。\n\nA: はい、元気です。こっちは今雨が降っています。\n\nB: (__________________)\n\nA: そっちはどうですか。\n\nB: いい天気です。',
        options: ['だいじょうぶですか', 'いいです', 'たいへんですね'],
        correctIndex: 2,
      ),
      Question(
        id: 19,
        section: 2,
        questionText:
            'A: 先生は今どちらですか。\n\nB: 先生は今図書館に (_____________)',
        options: ['ございます', 'おっしゃいます', 'いらっしゃいます'],
        correctIndex: 2,
      ),
      Question(
        id: 20,
        section: 2,
        questionText:
            'A: 昨日から少しねつがあって頭がいたいです。\n\nB: それは、 (_________)',
        options: ['おげんきで', 'いけませんね', 'しつれいします'],
        correctIndex: 1,
      ),
    ];

    final section3Questions = [
      Question(
        id: 21,
        section: 3,
        questionText: 'You will hear two people talking about Tokyo. What is the answer?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 3,
      ),
      Question(
        id: 22,
        section: 3,
        questionText: 'You will hear two people talking about eco-friendly activities.',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      Question(
        id: 23,
        section: 3,
        questionText: '3 people are talking in the exhibition hall. What are they talking about?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      Question(
        id: 24,
        section: 3,
        questionText: 'What was the present given by Nodasan?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 1,
      ),
      Question(
        id: 25,
        section: 3,
        questionText: 'What would that person do if a hole opened and couldn\'t wear socks anymore?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      Question(
        id: 26,
        section: 3,
        questionText: 'You can hear an audio about kimusan. What kind of child is he?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 2,
      ),
      Question(
        id: 27,
        section: 3,
        questionText: 'What kind of food manners are in France?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      Question(
        id: 28,
        section: 3,
        questionText: 'You can hear an audio about food order in a restaurant.',
        options: ['A', 'B', 'C'],
        correctIndex: 2,
      ),
      Question(
        id: 29,
        section: 3,
        questionText: 'According to the audio how did Saito san become a fan?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 0,
      ),
      Question(
        id: 30,
        section: 3,
        questionText: 'According to the audio what is this person doing during the year?',
        options: ['A', 'B', 'C'],
        correctIndex: 1,
      ),
    ];

    final section4Questions = [
      Question(
        id: 31,
        section: 4,
        questionText: 'カーラさんはどのときまで自分で日本語をならいましたか。',
        options: ['大学を卒業するまで', '専門学校を卒業するまで', '高校を卒業するまで'],
        correctIndex: 2,
      ),
      Question(
        id: 32,
        section: 4,
        questionText: '正しいものはどれか。',
        options: [
          'なかむらさんは10回以上京都へ来ました。',
          'ルさんはしょかい京都へきました。',
          'キムさんは1回も京都へ来たことがありません。'
        ],
        correctIndex: 1,
      ),
      Question(
        id: 33,
        section: 4,
        questionText: '説明にあうのはどれか。',
        options: [
          '私は去年父に青いネクタイをあげました。',
          '私は今年父の日に青いシャツをあげます。',
          '私は去年より今年も父にプレゼントをあげたいです。',
          '赤いは父の好きないろです。'
        ],
        correctIndex: 2,
      ),
      Question(
        id: 34,
        section: 4,
        questionText: '正しいものはどれか。',
        options: [
          'この人は漢字がとてもじょうずです。',
          'この人は日本語は何でも読めます。',
          'この人は日本語と日本文化が好きです。'
        ],
        correctIndex: 2,
      ),
      Question(
        id: 35,
        section: 4,
        questionText: 'メロスはどうして町に来ましたか。',
        options: [
          'おうさまを会うために',
          '妹の結婚式の買い物のために',
          'メロスのしんせきを会うために'
        ],
        correctIndex: 1,
      ),
      Question(
        id: 36,
        section: 4,
        questionText: 'どうしてこの男の人は30分おくれますか。',
        options: ['病気ですから', 'バスがこなかったから', '事故があったから'],
        correctIndex: 2,
      ),
      Question(
        id: 37,
        section: 4,
        questionText: 'レストラン「ハンナ」はどんなレストランですか。',
        options: ['ファミリーレストランです。', 'ようしょくのレストランです。', 'アメリカのレストランです。'],
        correctIndex: 1,
      ),
      Question(
        id: 38,
        section: 4,
        questionText: '一番目の男の子と言うのは何の意味ですか。',
        options: ['家族ではじめにうまれた女の子', '家族ではじめにうまれた男の子', '家族の一人っ子'],
        correctIndex: 1,
      ),
      Question(
        id: 39,
        section: 4,
        questionText: '女の人はどうやってほっかいどうへ行きますか。',
        options: ['ふね', 'バスで', 'ひこうきで', '車で'],
        correctIndex: 2,
      ),
      Question(
        id: 40,
        section: 4,
        questionText: '日本語を学びたいです。どこへ行きますか。',
        options: ['7のストール', '2.2時にステージの前', '10時にステージの前'],
        correctIndex: 1,
      ),
    ];

    questions = [
      ...section1Questions,
      ...section2Questions,
      ...section3Questions,
      ...section4Questions,
    ];
  }

  List<Question> getQuestionsForSection(int section) {
    return questions.where((q) => q.section == section).toList();
  }

  Question getCurrentQuestion() {
    final sectionQuestions = getQuestionsForSection(currentSection);
    if (currentQuestionIndex < sectionQuestions.length) {
      return sectionQuestions[currentQuestionIndex];
    }
    return sectionQuestions.last;
  }

  int getTotalQuestionsForSection(int section) {
    return getQuestionsForSection(section).length;
  }

  bool isAllQuestionsAnswered(int section) {
    final sectionQuestions = getQuestionsForSection(section);
    for (final q in sectionQuestions) {
      if (q.selectedIndex == null) return false;
    }
    return true;
  }

  int calculateTotalScore() {
    if (sectionResults.isEmpty) return 0;
    final avg = sectionResults.fold(0.0, (sum, sr) => sum + sr.score) / 4;
    return (avg * 2.5).round();
  }

  String getLevelDisplay(int totalScore) {
    if (totalScore >= 200) return '✅ PASSED - A2';
    if (totalScore >= 175) return '✅ PASSED - A2.1';
    if (totalScore >= 145) return '✅ PASSED - A1';
    return '❌ FAILED - Below A1';
  }

  Color getLevelColor(int totalScore) {
    if (totalScore >= 200) return Colors.green.shade700;
    if (totalScore >= 175) return Colors.blue.shade700;
    if (totalScore >= 145) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  void finishSection(int section) {
    if (isExamFinished) return;
    
    final sectionQuestions = getQuestionsForSection(section);
    int correct = 0;
    int total = sectionQuestions.length;

    for (final q in sectionQuestions) {
      if (q.selectedIndex == q.correctIndex) {
        correct++;
      }
    }

    final percent = (correct / total) * 100;
    final sectionNames = {
      1: 'Script and Vocabulary',
      2: 'Conversation and Expression',
      3: 'Listening Comprehension',
      4: 'Reading Comprehension',
    };

    sectionResults.add(
      SectionResult(
        sectionNumber: section,
        name: sectionNames[section] ?? 'Section $section',
        score: percent,
        correctCount: correct,
        totalCount: total,
      ),
    );

    if (section < 4) {
      currentSection = section + 1;
      currentQuestionIndex = 0;
    } else {
      isExamFinished = true;
      isTimerRunning = false;
    }
  }

  void resetExam() {
    for (int i = 0; i < questions.length; i++) {
      questions[i] = questions[i].copyWith(
        selectedIndex: null,
      );
    }
    currentSection = 1;
    currentQuestionIndex = 0;
    isExamFinished = false;
    isReviewMode = false;
    sectionResults = [];
    timeLeft = 3600;
    isTimeout = false;
  }
}