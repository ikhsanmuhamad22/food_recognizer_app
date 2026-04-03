import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_recognition_app/data/model/food_model.dart';
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
    print('Received image path: ${widget.imagePath}');
    if (widget.imagePath.isNotEmpty) {
      readViewmodel.runClassificationFromPath(widget.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Food data = Food(
      foodName: 'Nasi Goreng',
      nutrition: Nutrition(
        kalories: 200,
        carbs: 30,
        protein: 5,
        fat: 10,
        fiber: 2,
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Consumer<ImageClassificationViewmodel>(
          builder: (context, viewmodel, child) {
            if (viewmodel.classifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
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
                Flex(
                  direction: Axis.vertical,
                  children: [
                    // Baris atas
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: _nutrientBox(
                            '🔥',
                            data.nutrition.kalories.toString(),
                            'Calories (kcal)',
                            Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _nutrientBox(
                            '💪',
                            data.nutrition.protein.toString(),
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
                            data.nutrition.carbs.toString(),
                            'Carbs',
                            Colors.amber,
                          ),
                        ),
                        Expanded(
                          child: _nutrientBox(
                            '💧',
                            data.nutrition.fat.toString(),
                            'Total Fats',
                            Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      readViewmodel.close();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
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
