import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tracker/screens/add_child_screen.dart';
import 'package:tracker/screens/home_screen.dart';
import 'package:tracker/shared/cache_helper.dart';
import 'package:tracker/screens/signup_screen.dart';


import '../model/user_model.dart';
import '../shared/consteant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'layout_screen.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController  _EmailTextController = TextEditingController();
  final TextEditingController  _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SokarCubit(),
      child: BlocConsumer<SokarCubit, SokarState>(
        listener: (context,state ){
          if(state is LoginSuccessState){
            SokarCubit.get(context).getUserData();
            CacheHelper.saveData(
                key: 'userId',
                value: state.uid
            ).then((value)async{
              uid =state.uid;
              print('hereeeeeee');
              print(uid);
              SokarCubit.get(context).getUserData();
              print('nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn');
              await FirebaseFirestore.instance.collection('users').doc(uid).snapshots().forEach((element) {
                if(element.data()?['emil'] ==_EmailTextController.text){
                  print('i user');
                  element.data()?['kidName']== null ?
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddchildScreen()))
                    :Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LayoutScreen()));
                ;
                }else{
                  showModalBottomSheet(context: context, builder: (context){
                    return Container(
                      height: 300,
                      color: Colors.red,
                      child: Center(
                        child: Column(
                          children: [
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                            }, child:Column(
                              children: [
                                Text('Email or Password isnot correct',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                                Text('back to login',style: TextStyle(color: Colors.black),),
                              ],
                            )),
                          ],
                        ),
                      ),
                    );
                  }
                  );
                }
              });

            }).catchError((error){});
          }
          if(state is LoginErrorState){
            _showErrorDialog('Email or Password isnot correct', context!, LoginScreen());

          }
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
                      height: 400,
                      child: Image.asset('assets/background.png', fit: BoxFit.cover,),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 241,
                              height: 241,
                              child: Image.asset('assets/loginback.png')
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          height:  MediaQuery.of(context).size.height * 3 / 5,
                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(27),
                          ),
                          child:  Center(
                            child: ModalProgressHUD(
                              inAsyncCall: SokarCubit.get(context).showSpinner,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Login in',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('email adress',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 45,
                                        child: TextFormField(

                                          textAlignVertical: TextAlignVertical.top,
                                          decoration:  InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor)
                                              ),
                                              // border: OutlineInputBorder(),

                                          ),
                                          cursorColor: PrimaryColor,
                                          controller:_EmailTextController ,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return "Enter your Email";
                                            }
                                            final bool isValid = EmailValidator.validate(value);
                                            if(!isValid){
                                              return "invaild Email";
                                            }
                                            return null;
                                          },
                                          onChanged: (value){
                                            value = _EmailTextController.text;
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('password',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 45,
                                        child: TextFormField(
                                          textAlignVertical: TextAlignVertical.top,
                                          obscureText: true,
                                          decoration:  InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: PrimaryColor)
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: PrimaryColor)
                                            ),
                                            // border: OutlineInputBorder(),
                                            suffixIcon: Icon(Icons.remove_red_eye,color: PrimaryColor,),

                                          ),
                                          cursorColor: PrimaryColor,
                                          controller:_passwordController ,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return "Enter your password";
                                            }
                                          },

                                          onChanged: (value){
                                            value = _passwordController.text;
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: ()async{
                                              await FirebaseAuth.instance.sendPasswordResetEmail(email: _EmailTextController.text);
                                            },
                                              child: Text('Forgot password ?',style: TextStyle(color:PrimaryColor),)
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 40),
                                      GestureDetector(
                                        onTap: () async {
                                          if (_formKey.currentState!.validate()) {
                                            SokarCubit.get(context).playSpinner();
                                            await SokarCubit.get(context).userLogin(
                                              email: _EmailTextController.text,
                                              password: _passwordController.text,
                                            );

                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: PrimaryColor
                                          ),
                                          child: Center(
                                              child: Text('Log in',style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white
                                              ),)
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Dont have an account ?'),
                                          TextButton(onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                                          }, child: Text('SignUp'))
                                        ],
                                      ),


                                    ],
                                  ),
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
            ),
          );

        },
      ),
    );

  }
  void _showErrorDialog(String errorMessage,BuildContext context,Widget screen) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            GestureDetector(
              child: Text('OK'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>screen));
              },
            ),
          ],
        );
      },
    );
  }

}



