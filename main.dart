


import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/shared/bloc_observer.dart';
import 'package:tracker/shared/cache_helper.dart';
import 'package:tracker/screens/splash_screen.dart';


import 'shared/consteant.dart';
import 'cubit/cubit.dart';
import 'screens/home_screen.dart';
import 'screens/layout_screen.dart';
import 'screens/login_screen.dart';

main()async{
  Bloc.observer = const SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  await CacheHelper.init();

  Widget widget;

  uid=CacheHelper.getData(key:'userId');

  if(uid != null){
    widget = LayoutScreen();
  }else{
    widget = SplashScreen();
  }



  runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
              create:(BuildContext context)=>SokarCubit()..getUserData()
          ),
        ],
        child: MyApp(
          startWidget :widget,
        ),
      ));
  //runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key,required this.startWidget}) : super(key: key);
  final Widget startWidget;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  widget.startWidget,
    );
  }
}

