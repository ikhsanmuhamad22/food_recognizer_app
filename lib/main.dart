import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_recognition_app/data/model/meals_response.dart';
import 'package:food_recognition_app/firebase_options.dart';
import 'package:food_recognition_app/provider/reference_meal_provider.dart';
import 'package:food_recognition_app/service/api_service.dart';
import 'package:food_recognition_app/service/firebase_ml_service.dart';
import 'package:food_recognition_app/service/gemini_service.dart';
import 'package:food_recognition_app/ui/reference_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:food_recognition_app/controller/home_controller.dart';
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
        Provider(create: (context) => ApiServices()),
        Provider(create: (context) => GeminiService()),
        ChangeNotifierProvider(
          create:
              (context) => ReferenceMealProvider(
                apiServices: context.read<ApiServices>(),
              ),
        ),
        ChangeNotifierProvider(create: (context) => HomeController()),
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
        '/reference_meal':
            (context) => ReferenceDetailPage(
              data: ModalRoute.of(context)!.settings.arguments as Meal,
            ),
      },
    );
  }
}
