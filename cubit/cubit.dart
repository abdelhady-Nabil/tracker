




import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/screens/signup_screen.dart';

import '../shared/consteant.dart';
import '../screens/login_screen.dart';
import '../model/user_model.dart';
import '../shared/cache_helper.dart';
import 'states.dart';

class SokarCubit extends Cubit<SokarState>{

  SokarCubit() : super(SokarInitialState());

  static SokarCubit get(context) => BlocProvider.of(context);

  //indecator progress
  bool showSpinner = false;

  void playSpinner(){
    showSpinner=true;

  }
  void stopSpinner(){
    showSpinner=false;
  }

  bool obsecuer = true;

  void openObsecuer(){
    obsecuer = false;
    emit(OpenObsecuerState());
  }

  void closeObsecuer(){
    obsecuer = true;
    emit(OpenObsecuerState());
  }




  //register user
  Future<void> userRegister({
    required String name,
    required String email,
    required String password,
    BuildContext? context

  }) async {
    emit(RegisterLoadingState());
    try {
      var value = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      uid =value.user!.uid; //gamedddddddd ya abdoooooo wallahyyyyyyyyyy
      await userCreate(
        uid: value.user!.uid,
        email: email,
        password: password,
        name: name,
      );
      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if(e.code == 'weak-password'){
        print('the password is too weak');
        _showErrorDialog('the password is too weak',context!,SignupScreen());
      }
      else if(e.code == 'email-already-in-use'){
        print('the account already exists for that email');
        _showErrorDialog('the account already exists for that email',context!,SignupScreen());
      }
      print("Error during user registration: $e");
      emit(RegisterErrorState());
    }
  }

  //use it in userRegister above
  Future<void> userCreate({
    required String email,
    required String name,
    required String password,
    required String uid,
    String? kidName,
    String? gender,
  }) async {
    UserModel model = UserModel(
      email: email,
      password: password,
      userId: uid,
      name: name,
      kidName: kidName,
      gender: gender
    );
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(model.toMap());
      emit(CreateUserSuccessState());
    } catch (error) {
      print("Error during user creation: $error");
      emit(CreateUserErrorState());
    }
  }




  // Future<void> userLogin1({
  //   required String email,
  //   required String password,
  // }) async {
  //   emit(LoginLoadingState());
  //   await FirebaseFirestore.instance.collection('users').doc(uid).snapshots().forEach((element) {
  //     if(element.data()?['emil'] ==email && element.data()?['password']==password){
  //       print('i user');
  //
  //     }else{
  //
  //     }
  //   });
  // }
  Future<void> userLogin({
    required String email,
    required String password,
    BuildContext? context
  }) async {
    emit(LoginLoadingState());
    try {
      var value = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccessState(value.user!.uid));
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        print('no user found for that email ');
        _showErrorDialog('no user found for that email',context!,LoginScreen());

      }
      else if(e.code == 'wrong-password'){
        print('wrong password provided for that user ');
        _showErrorDialog('wrong password provided for that user',context!,LoginScreen());

      }

      print("Error during user login: $e");
      emit(LoginErrorState());
    }
  }

  UserModel? model;

  Future<void> getUserData() async {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      print(value.data()); // is map
      print(uid);
      print('ddddddddddddddd');
      print('${value.id}');
      uid=value.id;
      model = UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserErrorState());
    });
  }



  void signOut(context) {
    CacheHelper.removeDate(key: 'userId')
        .then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
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