import 'package:flutter/material.dart';
import 'package:food_recognition_app/data/model/meals_response.dart';

class ReferenceDetailPage extends StatelessWidget {
  final Meal data;

  const ReferenceDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Reference Meal Detail',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(child: _ReferenceDetailBody(data: data)),
    );
  }
}

class _ReferenceDetailBody extends StatelessWidget {
  final Meal data;

  const _ReferenceDetailBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> expanded = ValueNotifier(false);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image.network(
                data.strMealThumb ?? 'https://via.placeholder.com/150',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${data.strArea} meals',

                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Text(
              data.strMeal,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  data.ingredients.isEmpty
                      ? Text(
                        'No ingredients available.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.black87),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            data.ingredients.join(', '),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.black87),
                          ),
                        ],
                      ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(16),
              ),
              child:
                  data.strInstructions!.isEmpty
                      ? Text(
                        'No instructions available.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.black87),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instructions to Cook',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => expanded.value = !expanded.value,
                            child: ValueListenableBuilder<bool>(
                              valueListenable: expanded,
                              builder: (context, isExpanded, child) {
                                return Text(
                                  maxLines: isExpanded ? null : 5,
                                  overflow:
                                      isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                  data.strInstructions ??
                                      'No instructions available.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.black87),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
