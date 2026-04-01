import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/provider/image_classification_provider.dart';
import 'package:submission/widget/classification_item.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result Page'),
      ),
      body: SafeArea(child: _ResultBody(imagePath: imagePath!)),
    );
  }
}

class _ResultBody extends StatefulWidget {
  const _ResultBody({required this.imagePath});

  final String imagePath;

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  late final readViewmodel = context.read<ImageClassificationViewmodel>();

  @override
  void dispose() {
    Future.microtask(() async => await readViewmodel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Expanded(
          child: Center(
            child: Image.file(File(widget.imagePath), fit: BoxFit.contain),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          // todo-03: show the inference result (food name and the confidence score)
          child: Consumer<ImageClassificationViewmodel>(
            builder: (_, updateViewmodel, __) {
              final classifications = updateViewmodel.classifications.entries;

              if (classifications.isEmpty) {
                return const SizedBox.shrink();
              }
              return SingleChildScrollView(
                child: Column(
                  children:
                      classifications
                          .map(
                            (classification) => ClassificatioinItem(
                              item: classification.key,
                              value: classification.value.toStringAsFixed(2),
                            ),
                          )
                          .toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
