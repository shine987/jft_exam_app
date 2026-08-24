import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'models/exam_model.dart';
import 'models/settings_model.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ExamData()..initializeQuestions()),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);

    return MaterialApp(
      title: 'JFT Exam',
      theme: settings.isDarkMode
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
