import 'package:flutter/material.dart';
import 'package:food_recognition_app/provider/reference_meal_provider.dart';
import 'package:food_recognition_app/service/firebase_ml_service.dart';
import 'package:food_recognition_app/service/gemini_service.dart';
import 'package:food_recognition_app/service/image_classification_service.dart';
import 'package:food_recognition_app/ui/reference_detail_page.dart';
import 'package:food_recognition_app/widget/custem_image_widget.dart';
import 'package:food_recognition_app/widget/nutrition_box.dart';
import 'package:provider/provider.dart';
import 'package:food_recognition_app/data/model/food.dart';
import 'package:food_recognition_app/provider/image_classification_provider.dart';

class ResultPage extends StatelessWidget {
  final String imagePath;

  const ResultPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Result Page',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),

      body: MultiProvider(
        providers: [
          Provider(
            create:
                (context) => ImageClassificationService(
                  context.read<FirebaseMlService>(),
                ),
          ),
          ChangeNotifierProvider(
            create:
                (context) => ImageClassificationViewmodel(
                  context.read<ImageClassificationService>(),
                ),
          ),
        ],
        child: SafeArea(child: _ResultBody(imagePath: imagePath)),
      ),
    );
  }
}

class _ResultBody extends StatefulWidget {
  final String imagePath;

  const _ResultBody({required this.imagePath});

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  late final ImageClassificationViewmodel readViewmodel;

  @override
  void initState() {
    super.initState();
    readViewmodel = context.read<ImageClassificationViewmodel>();
    if (widget.imagePath.isNotEmpty) {
      readViewmodel.runClassificationFromPath(widget.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Consumer<ImageClassificationViewmodel>(
          builder: (context, viewmodel, child) {
            final data = viewmodel.classifications;
            if (data.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<ReferenceMealProvider>(
                context,
                listen: false,
              ).fetchMeals(viewmodel.classifications.keys.first);
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                CustomImageWidget(data: data, image: widget.imagePath),

                const SizedBox(height: 24),
                Text(
                  'Nutrition Breakdown',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.black54),
                ),

                const SizedBox(height: 12),
                Consumer<GeminiService>(
                  builder: (context, geminiService, child) {
                    return FutureBuilder<Nutrition>(
                      future: geminiService.generateCommands(
                        viewmodel.classifications.keys.first,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('failed to load nutrition data');
                        } else {
                          final Nutrition response = snapshot.data!;
                          return Flex(
                            direction: Axis.vertical,
                            children: [
                              // Baris atas
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: nutrientBox(
                                      '🔥',
                                      response.calories.toString(),
                                      'Calories (kcal)',
                                      Colors.orange,
                                    ),
                                  ),
                                  Expanded(
                                    child: nutrientBox(
                                      '💪',
                                      response.protein.toString(),
                                      'Protein',
                                      Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              // Baris bawah
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: nutrientBox(
                                      '🥐',
                                      response.carbs.toString(),
                                      'Carbs',
                                      Colors.amber,
                                    ),
                                  ),
                                  Expanded(
                                    child: nutrientBox(
                                      '💧',
                                      response.fat.toString(),
                                      'Total Fats',
                                      Colors.brown,
                                    ),
                                  ),
                                  Expanded(
                                    child: nutrientBox(
                                      '🌾',
                                      response.fiber.toString(),
                                      'Fiber',
                                      Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 32),

                Consumer<ReferenceMealProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text('failed to load reference meals'),
                      );
                    }

                    final meals = provider.mealsResponse?.meals;
                    if (meals == null || meals.isEmpty) {
                      return SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reference and Similar Meals',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: meals.length > 2 ? 2 : meals.length,
                          itemBuilder: (context, index) {
                            final meal = meals[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            ReferenceDetailPage(data: meal),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      meal.strMealThumb ?? '',
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(meal.strMeal),
                                  subtitle: Text('click for details'),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      readViewmodel.close();
                      Navigator.pop(context);
                    },
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
