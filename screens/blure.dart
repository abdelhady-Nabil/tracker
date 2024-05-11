// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class FaceBlurPage extends StatefulWidget {
//   const FaceBlurPage({Key? key}) : super(key: key);
//
//   @override
//   State<FaceBlurPage> createState() => _FaceBlurPageState();
// }
//
// class _FaceBlurPageState extends State<FaceBlurPage> {
//   String pixlabkey = "b4921feaedaf0b16d03113235b3d28c1";
//   String? imagelink;
//   String? blurImagelink;
//
//   final picker = ImagePicker();
//   var dio = Dio();
//
//   Future<void> uploadImageToFirebase(File imageFile) async {
//     try {
//       FirebaseStorage storage = FirebaseStorage.instance;
//       Reference ref = storage.ref().child("images/${DateTime.now().millisecondsSinceEpoch}.png");
//       UploadTask uploadTask = ref.putFile(imageFile);
//       TaskSnapshot storageTaskSnapshot = await uploadTask;
//       String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
//       setState(() {
//         imagelink = downloadUrl;
//       });
//     } catch (e) {
//       print('Error uploading image to Firebase Storage: $e');
//     }
//   }
//
//   Future<Response> detectFaces(String image) async {
//     return dio.get(
//       "https://api.pixlab.io/facedetect",
//       queryParameters: {
//         "img": image,
//         "key": pixlabkey,
//       },
//     );
//   }
//
//   Future<Response> blurface(String image, List coordinates) async {
//     return await dio.post(
//       "https://api.pixlab.io/mogrify",
//       data: {
//         "img": image,
//         "key": pixlabkey,
//         "cord": coordinates,
//       },
//       options: Options(contentType: "application/json"),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Face Blur Example"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Show the blurred image if blurImagelink is not null
//             if (blurImagelink != null)
//               Image.network(blurImagelink!),
//             // Show a circular progress indicator if blurImagelink is null
//             if (blurImagelink == null)
//               const CircularProgressIndicator(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//           if (pickedFile != null) {
//             setState(() {
//               imagelink = null;
//               blurImagelink = null;
//             });
//             File imageFile = File(pickedFile.path);
//             await uploadImageToFirebase(imageFile);
//             if (imagelink != null) {
//               Response faces = await detectFaces(imagelink!);
//               setState(() {
//                 imagelink = imagelink;
//               });
//               Response blurfaceImageResponse = await blurface(imagelink!, faces.data["faces"]);
//               setState(() {
//                 blurImagelink = blurfaceImageResponse.data["ssl_link"];
//               });
//             }
//           }
//         },
//         child: const Icon(Icons.auto_mode_rounded),
//       ),
//     );
//   }
// }
