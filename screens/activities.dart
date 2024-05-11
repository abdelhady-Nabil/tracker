import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/screens/layout_screen.dart';
import 'package:tracker/shared/consteant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'login_screen.dart';
import '../model/user_model.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  late UserModel model;

  @override
  void initState() {
    super.initState();
    SokarCubit.get(context).getUserData().then((_) {
      setState(() {
        model = SokarCubit.get(context).model!;
      });
    });
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: model?.image != null
                                      ? NetworkImage('${model!.image}')
                                      : AssetImage('assets/girl.png') as ImageProvider<Object>?,                                  radius: 25,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      model?.kidName ?? 'Loading...',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text('online'),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Transform.rotate(
                                          angle: 90 * 3.1415926535 / 180, // Angle in radians, here 90 degrees
                                          child: Icon(Icons.battery_4_bar_rounded, color: Colors.green),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text('89%'),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    SokarCubit.get(context).signOut(context);
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  },
                                  icon: Icon(Icons.logout),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Current Location ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 30,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color.fromRGBO(244, 244, 244, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey, // Shadow color
                                    blurRadius: 4,     // Spread radius
                                    offset: Offset(0, 2), // Offset in x and y direction
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8,top: 0,bottom: 0),
                                child: Row(
                                  children: [
                                    Text('Home',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),

                                    Spacer(),
                                    Icon(Icons.home,color: Colors.green,size: 18,),


                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LayoutScreen()));
                                    }, icon: Icon(Icons.arrow_back)),
                                    Text(
                                      'recent activities ',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                    ),
                                    ],
                                ),
                          
                                SizedBox(
                                  height: 20,
                                ),
                          
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Item(
                                            model: model
                                        ),
                                        Item(
                                          model: model
                                        ),
                                        Item(
                                            model: model
                                        ),
                                        Item(
                                            model: model
                                        ),
                                        Item(
                                            model: model
                                        ),
                                        Item(
                                            model: model
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          
                          
                          
                          
                              ],
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

Widget Item({
  UserModel? model,
}) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Container(
      width: 390,
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(201, 47, 255, 0.12)
      ),
      child:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: model?.image != null
                      ? NetworkImage('${model!.image}')
                      : AssetImage('assets/girl.png') as ImageProvider<Object>?,                  radius: 30,
                ),
                SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model?.kidName ?? 'Loading...',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text('online'),
                        SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.watch_later_outlined,size: 12,),
                        SizedBox(
                          width: 2,
                        ),
                        Text('5 min ago',style: TextStyle(fontSize: 12),),
                        SizedBox(
                          width: 4,
                        ),
                      ],
                    ),
                  ],
                ),

                Expanded(child:  Container(
                  height: 30,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Laila is walking now in the abbas strt',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                )),

              ],
            ),


          ],
        ),
      ) ,
    ),
  );
}