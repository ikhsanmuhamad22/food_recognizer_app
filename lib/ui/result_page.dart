import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_recognition_app/provider/reference_meal_provider.dart';
import 'package:food_recognition_app/service/gemini_service.dart';
import 'package:food_recognition_app/ui/reference_detail_page.dart';
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
      body: SafeArea(child: _ResultBody(imagePath: imagePath)),
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
            if (viewmodel.classifications.isEmpty) {
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
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.file(File(widget.imagePath)).image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Gradient agar teks lebih terbaca
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      // Teks label dan confidence
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewmodel.classifications.keys.first,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(viewmodel.classifications.values.first * 100).toStringAsFixed(0)}% Confidence',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                          return Text('Error: ${snapshot.error}');
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
                                    child: _nutrientBox(
                                      '🔥',
                                      response.calories.toString(),
                                      'Calories (kcal)',
                                      Colors.orange,
                                    ),
                                  ),
                                  Expanded(
                                    child: _nutrientBox(
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
                                    child: _nutrientBox(
                                      '🥐',
                                      response.carbs.toString(),
                                      'Carbs',
                                      Colors.amber,
                                    ),
                                  ),
                                  Expanded(
                                    child: _nutrientBox(
                                      '💧',
                                      response.fat.toString(),
                                      'Total Fats',
                                      Colors.brown,
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
                Text(
                  'Reference and Similar Meals',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 12),

                Consumer<ReferenceMealProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.errorMessage != null) {
                      return Center(
                        child: Text('Error: ${provider.errorMessage}'),
                      );
                    }

                    final meals = provider.mealsResponse?.meals;
                    if (meals == null || meals.isEmpty) {
                      return const Center(child: Text('Tidak ada hasil'));
                    }

                    return ListView.builder(
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

Widget _nutrientBox(String icon, String value, String label, Color color) {
  return Container(
    margin: const EdgeInsets.all(4),
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}
