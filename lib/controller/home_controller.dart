// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  String? selectedImagePath;

  Future<void> _cropImage(String imagePath, BuildContext context) async {
    selectedImagePath = null;
    notifyListeners();
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
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
      selectedImagePath = croppedFile.path;
      notifyListeners();
      // Navigate to result page with cropped image
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ResultPage(imagePath: croppedFile.path),
      //   ),
      // );
    }
  }

  Future<void> pickImageFromCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _cropImage(image.path, context);
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _cropImage(image.path, context);
    }
  }

  void goToResultPage(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ResultPage(imagePath: '')),
    // );
  }
}
