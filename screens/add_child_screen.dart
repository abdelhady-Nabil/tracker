import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tracker/shared/cache_helper.dart';
import 'package:tracker/screens/signup_screen.dart';


import '../shared/consteant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'layout_screen.dart';


class AddchildScreen extends StatefulWidget {
  @override
  State<AddchildScreen> createState() => _AddchildScreenState();
}

class _AddchildScreenState extends State<AddchildScreen> {
  final TextEditingController  _name = TextEditingController();

  final TextEditingController  _gender = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SokarCubit(),
      child: BlocConsumer<SokarCubit, SokarState>(
        listener: (context,state ){
        },
        builder: (context,state ){
          return Form(
            key: _formKey,
            child: Scaffold(
              body: Center(
                child: Stack(

                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset('assets/b2.png', fit: BoxFit.cover,),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 300,
                                      height: 300,
                                      child: Image.asset('assets/addchild.png')
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: ModalProgressHUD(
                                    inAsyncCall: SokarCubit.get(context).showSpinner,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Hi new tracker',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('what is your Kid name',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 45,
                                          child: TextFormField(
                                            textAlignVertical: TextAlignVertical.top,
                                            decoration: InputDecoration(
                                              filled: true, // Set filled to true
                                              fillColor: Colors.white, // Set the background color to white
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              // border: OutlineInputBorder(),
                                            ),
                                            cursorColor: PrimaryColor,
                                            controller: _name,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Enter your kid name";
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              value = _name.text;
                                            },
                                          ),

                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('gender',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 45,
                                          child: Stack(
                                            children: [
                                              TextFormField(
                                                textAlignVertical: TextAlignVertical.top,
                                                readOnly: true, // Make the field read-only
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor),
                                                  ),
                                                  // border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons.arrow_drop_down_outlined, color: PrimaryColor),
                                                ),
                                                cursorColor: PrimaryColor,
                                                controller: _gender,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Enter gender of kid";
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  value = _gender.text;
                                                },
                                              ),
                                              Positioned(
                                                right: 0,
                                                left: 0,
                                                bottom: 0,
                                                child: PopupMenuButton<String>(
                                                  icon: Container(), // Hide the default icon
                                                  onSelected: (String value) {
                                                    setState(() {
                                                      _gender.text = value;
                                                    });
                                                  },
                                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                    PopupMenuItem<String>(
                                                      value: 'Male',
                                                      child: Text('Male'),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      value: 'Female',
                                                      child: Text('Female'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 40),
                                        GestureDetector(
                                          onTap: () async {
                                            if (_formKey.currentState!.validate()) {
                                              SokarCubit.get(context).playSpinner();

                                              // Update the user document in Firestore
                                              FirebaseFirestore.instance.collection('users').doc(uid).update({
                                                'kidName': _name.text,
                                                'gender': _gender.text,
                                              }).then((_) {
                                                // Handle success
                                                print('Kid name and gender updated successfully');
                                                // Navigate to the layout screen
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => LayoutScreen()),
                                                );
                                              }).catchError((error) {
                                                // Handle error
                                                print('Failed to update kid name and gender: $error');
                                                // Display an error message to the user
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Failed to update kid name and gender'),
                                                  ),
                                                );
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: PrimaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Start now',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),



                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          );

        },
      ),
    );

  }
}



