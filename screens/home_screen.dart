import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/shared/consteant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'activities.dart';
import 'login_screen.dart';
import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                                      : AssetImage('assets/girl.png') as ImageProvider<Object>?,
                                  radius: 25,
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
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset('assets/school.png'),
                                      Positioned(
                                        top: 100,
                                        left: 20,
                                        child: GestureDetector(
                                          onTap: (){},
                                          child: Container(
                                          width: 97,
                                          height: 35,
                                          color: Colors.transparent,
                                                                                ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'recent activities ',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                      ),
                                      Spacer(),
                                      TextButton(
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ActivitiesScreen()));
                                          },
                                          child: Text('see all',style: TextStyle(color: PrimaryColor,fontSize: 20),))
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  Container(
                                    width: 390,
                                    height: 160,
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
                                                    : AssetImage('assets/girl.png') as ImageProvider<Object>?,                                                radius: 35,
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                     Icon(Icons.watch_later_outlined,size: 15,),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text('5 min ago',style: TextStyle(fontSize: 12),),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 50,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Laila is walking in the abbas strt and she stopped there for 5 min  ',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ) ,
                                  ),




                                ],
                              ),
                            ),
                          ),

                        ),
                      ),








                      // Container(
                      //   width: double.infinity,
                      //   height: 200,
                      //   decoration: BoxDecoration(
                      //       color: Colors.red[100],
                      //       borderRadius: BorderRadius.circular(20)
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(20.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             Icon(Icons.heart_broken_outlined),
                      //             SizedBox(
                      //               width: 10,
                      //             ),
                      //             Text('Heart Rate',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      //
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Text('last',style: TextStyle(fontSize: 18,),),
                      //         Text('Monument',style: TextStyle(fontSize: 18,),),
                      //
                      //         SizedBox(
                      //           height:25,
                      //         ),
                      //         Row(
                      //           children: [
                      //             Text('78/ ',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                      //             Text('bpm',style: TextStyle(fontSize: 18,),),
                      //
                      //           ],
                      //         ),
                      //
                      //       ],
                      //     ),
                      //   ),
                      // )




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
