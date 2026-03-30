import 'package:flutter/material.dart';

class HowToUseItem extends StatelessWidget {
  final String number;
  final String description;
  const HowToUseItem({
    super.key,
    required this.number,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24, // Box width
          height: 24, // Box height
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary, // Background color
            borderRadius: BorderRadius.circular(50), // Rounded corners
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        const SizedBox(width: 16), // Spacing between boxes
        Expanded(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
