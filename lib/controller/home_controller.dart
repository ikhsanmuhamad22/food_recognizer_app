import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:submission/ui/result_page.dart';

class HomeController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromCamera(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Navigate to result page with image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(imagePath: image.path),
        ),
      );
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    print("pick image from gallery");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Navigate to result page with image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(imagePath: image.path),
        ),
      );
    }
  }

  void goToResultPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultPage()),
    );
  }
}
