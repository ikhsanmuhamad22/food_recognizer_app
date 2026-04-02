import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:submission/provider/image_classification_provider.dart';
import 'package:submission/service/image_classification_service.dart';
import 'package:submission/widget/camera_view.dart';
import 'package:submission/widget/classification_item.dart';
import 'package:submission/ui/result_page.dart';

class LiveCameraPage extends StatelessWidget {
  const LiveCameraPage({super.key});

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
          // todo-05-ui-01: inject all classes
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
            child: _LiveCameraBody(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Capture image logic will be handled in _LiveCameraBody
          final bodyState =
              context.findAncestorStateOfType<_LiveCameraBodyState>();
          if (bodyState != null) {
            await bodyState.captureAndProcessImage(context);
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}

class _LiveCameraBody extends StatefulWidget {
  const _LiveCameraBody();

  @override
  State<_LiveCameraBody> createState() => _LiveCameraBodyState();
}

class _LiveCameraBodyState extends State<_LiveCameraBody> {
  // todo-05-ui-03: setup the provider and dispose it after using it
  late final readViewmodel = context.read<ImageClassificationViewmodel>();
  Future<XFile?> Function()? _takePicture;

  @override
  void dispose() {
    Future.microtask(() async => await readViewmodel.close());
    super.dispose();
  }

  Future<void> captureAndProcessImage(BuildContext context) async {
    if (_takePicture != null) {
      final XFile? imageFile = await _takePicture!();
      if (imageFile != null) {
        // Crop the image
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: 'Crop Image', minimumAspectRatio: 1.0),
          ],
        );

        if (croppedFile != null) {
          // Run classification on the cropped image
          await readViewmodel.runClassificationFromPath(croppedFile.path);

          // Navigate to result page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CameraView(
          onImage: (cameraImage) async {
            await readViewmodel.runClassification(cameraImage);
          },
          onTakePicture: (takePictureFunc) {
            _takePicture = takePictureFunc;
          },
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
