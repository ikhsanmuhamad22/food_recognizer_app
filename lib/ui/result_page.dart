import 'package:flutter/material.dart';
import 'package:submission/data/model/food_model.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Result Page',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(child: _ResultBody()),
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody();

  @override
  Widget build(BuildContext context) {
    final confidence = 0.85;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/rendang.png',
                  ), // bisa diganti dengan FileImage atau NetworkImage
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
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
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
                          data.foodName,
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
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${(confidence * 100).toStringAsFixed(0)}% Confidence',
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
          ],
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
