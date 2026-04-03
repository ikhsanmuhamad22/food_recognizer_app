import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/controller/home_controller.dart';
import 'package:submission/provider/image_classification_provider.dart';
import 'package:submission/service/image_classification_service.dart';
import 'package:submission/widget/camera_view.dart';
import 'package:submission/widget/classification_item.dart';

class LiveCameraPage extends StatefulWidget {
  const LiveCameraPage({super.key});

  @override
  State<LiveCameraPage> createState() => _LiveCameraPageState();
}

class _LiveCameraPageState extends State<LiveCameraPage> {
  late HomeController controller;
  late Future<XFile?> Function() takePicture;
  bool isCameraReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = Provider.of<HomeController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Image Classification App'),
      ),
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: MultiProvider(
            providers: [
              Provider(create: (context) => ImageClassificationService()),
              ChangeNotifierProvider(
                create:
                    (context) => ImageClassificationViewmodel(
                      context.read<ImageClassificationService>(),
                    ),
              ),
            ],
            child: _LiveCameraBody(
              onTakePicture: (takePictureFunc) {
                setState(() {
                  takePicture = takePictureFunc;
                  isCameraReady = true;
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            isCameraReady
                ? () async {
                  final file = await takePicture();
                  if (file != null) {
                    controller.selectedImagePath = file.path;
                    controller.cropImage(file.path, context);
                  }
                }
                : null,
        child: const Icon(Icons.camera),
      ),
    );
  }
}

class _LiveCameraBody extends StatefulWidget {
  final Function(Future<XFile?> Function()) onTakePicture;

  const _LiveCameraBody({required this.onTakePicture});

  @override
  State<_LiveCameraBody> createState() => _LiveCameraBodyState();
}

class _LiveCameraBodyState extends State<_LiveCameraBody> {
  late final readViewmodel = context.read<ImageClassificationViewmodel>();

  @override
  void dispose() {
    Future.microtask(() async => await readViewmodel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          onImage: (cameraImage) async {
            await readViewmodel.runClassification(cameraImage);
          },
          onTakePicture: widget.onTakePicture,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
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
