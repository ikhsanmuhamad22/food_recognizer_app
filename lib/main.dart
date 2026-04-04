import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_recognition_app/firebase_options.dart';
import 'package:food_recognition_app/service/firebase_ml_service.dart';
import 'package:food_recognition_app/service/gemini_service.dart';
import 'package:provider/provider.dart';
import 'package:food_recognition_app/controller/home_controller.dart';
import 'package:food_recognition_app/provider/image_classification_provider.dart';
import 'package:food_recognition_app/service/image_classification_service.dart';
import 'package:food_recognition_app/style/main_theme.dart';
import 'package:food_recognition_app/ui/home_page.dart';
import 'package:food_recognition_app/ui/result_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseMlService()),
        Provider(
          create:
              (context) =>
                  ImageClassificationService(context.read<FirebaseMlService>()),
        ),
        Provider(create: (context) => GeminiService()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(
          create:
              (context) => ImageClassificationViewmodel(
                context.read<ImageClassificationService>(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recognizer App',
      theme: MainTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/result':
            (context) => ResultPage(
              imagePath: ModalRoute.of(context)!.settings.arguments as String,
            ),
      },
    );
  }
}
