import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tracker/screens/layout_screen.dart';
import 'package:tracker/shared/consteant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'login_screen.dart';
import '../model/user_model.dart';
import 'dart:io';


class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  late UserModel model;
  ImageProvider<Object>? _image; // Changed type to ImageProvider<Object>?
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    SokarCubit.get(context).getUserData().then((_) {
      setState(() {
        model = SokarCubit.get(context).model!;
      });
    });
  }
  Future<void> uploadImageAndUpdateFirestore() async {
    if (_image != null && _image is FileImage) {
      Reference ref = FirebaseStorage.instance.ref().child("profile_images").child("${DateTime.now()}.png");
      UploadTask uploadTask = ref.putFile((_image as FileImage).file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with the image URL
      String userId = FirebaseAuth.instance.currentUser!.uid; // Assuming you're using Firebase Authentication
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'image': downloadUrl,
      }).then((value) {
        // Image URL updated successfully
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User image updated successfully')));
      }).catchError((error) {
        // Handle error updating Firestore
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user image')));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SokarCubit()..getUserData(),
      child: BlocBuilder<SokarCubit, SokarState>(
        builder: (context, state) {
          final superCubit = context.read<SokarCubit>();
          UserModel? model = superCubit.model;

          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset('assets/b2.png', fit: BoxFit.cover,),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                                setState(() {
                                  if (pickedFile != null) {
                                    _image = FileImage(File(pickedFile.path));
                                  } else {
                                    print('No image selected.');
                                  }
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 140, // Adjust width and height according to your design
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: _image != null
                                          ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: _image!,
                                      )
                                          : model?.image != null
                                          ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(model!.image),
                                      )
                                          : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage('assets/girl.png'),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              model?.kidName ?? 'Loading...',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            SizedBox(height: 5),

                            GestureDetector(
                              onTap: () {
                                uploadImageAndUpdateFirestore().then((_) {
                                  setState(() {
                                    // Update the _image variable with the new image URL
                                    _image = NetworkImage(model?.image);
                                  });

                                  Navigator.push(context, MaterialPageRoute(builder: (contxt)=>LayoutScreen()));

                                }


                                );
                              },
                              child: Container(
                                width: 178,
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(166, 52, 168, 1)
                                ),
                                child: Center(
                                  child: Text(
                                    'Change the photo',style: TextStyle(
                                    color: Colors.white
                                  ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(27),topLeft: Radius.circular(27),bottomRight: Radius.circular(0),bottomLeft: Radius.circular(0),),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Please connect to the device ',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 80,
                                  ),

                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromRGBO(109, 125, 205, 1)
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'connect to Blutooth  ',style: TextStyle(
                                              color: Colors.white,
                                            fontSize: 20
                                          ),
                                          ),
                                          Icon(Icons.bluetooth,color: Colors.white,size: 22,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color.fromRGBO(235, 126, 126, 1)
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'connect to Kid\'s phone  ',style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20
                                          ),
                                          ),
                                          Icon(Icons.phone_android,color: Colors.white,size: 22,),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 70,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                      SokarCubit.get(context).signOut(context);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.red,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: Colors.red, // Set text color to red
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),





                                ],
                              ),
                            ),
                          ),

                        ),
                      ),






                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
