import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/controller/home_controller.dart';
import 'package:submission/provider/image_classification_provider.dart';
import 'package:submission/service/image_classification_service.dart';
import 'package:submission/style/main_theme.dart';
import 'package:submission/ui/home_page.dart';
import 'package:submission/ui/live_camera_page.dart';
import 'package:submission/ui/result_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ImageClassificationService()),
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
      title: 'Flutter Demo',
      theme: MainTheme.lightTheme,
      initialRoute: '/result',
      routes: {
        '/': (context) => const HomePage(),
        '/live_camera': (context) => const LiveCameraPage(),
        '/result': (context) => ResultPage(),
      },
    );
  }
}
