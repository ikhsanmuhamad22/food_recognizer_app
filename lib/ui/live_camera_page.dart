// import 'dart:async';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:submission/ui/result_page.dart';

// class LiveCameraPage extends StatefulWidget {
//   const LiveCameraPage({super.key});

//   @override
//   State<LiveCameraPage> createState() => _LiveCameraPageState();
// }

// class _LiveCameraPageState extends State<LiveCameraPage>
//     with WidgetsBindingObserver {
//   CameraController? _cameraController;
//   bool _isCameraInitialized = false;
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initializeCamera();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }

//     if (state == AppLifecycleState.inactive) {
//       _cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _initializeCamera();
//     }
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     if (cameras.isEmpty) {
//       return;
//     }

//     // Use back camera
//     final camera = cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.back,
//       orElse: () => cameras.first,
//     );

//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.medium, // Lower resolution for better performance
//       enableAudio: false,
//     );

//     try {
//       await _cameraController!.initialize();
//       await _cameraController!.lockCaptureOrientation(
//         DeviceOrientation.portraitUp,
//       );

//       if (mounted) {
//         setState(() {
//           _isCameraInitialized = true;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error initializing camera: $e');
//     }
//   }

//   Future<void> _captureAndCropImage() async {
//     if (_cameraController == null ||
//         !_cameraController!.value.isInitialized ||
//         _isProcessing) {
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       // Capture image from camera
//       final XFile capturedImage = await _cameraController!.takePicture();

//       // Crop the captured image
//       final croppedFile = await ImageCropper().cropImage(
//         sourcePath: capturedImage.path,
//         compressFormat: ImageCompressFormat.jpg,
//         compressQuality: 100,
//         uiSettings: [
//           AndroidUiSettings(
//             toolbarTitle: 'Crop Food Image',
//             toolbarColor: Theme.of(context).colorScheme.primary,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//           ),
//           IOSUiSettings(title: 'Crop Food Image', minimumAspectRatio: 1.0),
//         ],
//       );

//       if (croppedFile != null && mounted) {
//         // Navigate to result page with cropped image for classification
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResultPage(imagePath: croppedFile.path),
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error capturing/cropping image: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to capture image')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isCameraInitialized || _cameraController == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Capture Food Image'),
//           backgroundColor: Theme.of(context).colorScheme.primary,
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Capture Food Image'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: Stack(
//         children: [
//           // Camera Preview
//           CameraPreview(_cameraController!),

//           // Instruction Text
//           Positioned(
//             left: 16,
//             right: 16,
//             bottom: 120,
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.7),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Position food in frame and tap capture',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Image will be cropped before classification',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Capture Button
//           Positioned(
//             bottom: 30,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: FloatingActionButton(
//                 onPressed: _isProcessing ? null : _captureAndCropImage,
//                 backgroundColor:
//                     _isProcessing
//                         ? Colors.grey
//                         : Theme.of(context).colorScheme.primary,
//                 child:
//                     _isProcessing
//                         ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                         : const Icon(Icons.camera, size: 30),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
