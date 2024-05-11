import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker/screens/login_screen.dart';

import 'package:tracker/widget/widget.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

final PageController _pageController = PageController();

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Watch Your Kids',
      'description':
          'Through the application, you can track your child’s location and itinerary and receive an automatic alert if the places allocated to him run out',
      'image': 'assets/onbordeing1.png',
    },
    {
      'title': 'Watch Your Old People',
      'description':
          'Through the application, you can track the location of the elderly and check on their health condition',
      'image': 'assets/onboarding/onboarding2.png',
    },
    {
      'title': 'Keep Your Family Safe',
      'description':
          'Through the application, you can track the location of the elderly and check on their health condition',
      'image': 'assets/onboarding/onboarding3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingData.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return OnboardingPage(
            title: onboardingData[index]['title']!,
            description: onboardingData[index]['description']!,
            image: onboardingData[index]['image']!,
            pageNumber: _currentPage,
          );
        },
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int pageNumber;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/fb.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0,150,20,20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset(
                      image, // Replace with your image path
                      fit: BoxFit
                          .cover, // Use BoxFit.cover to fill the container
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:
                          20, // Adjust the width to change the size of the circle
                      height:
                          20, // Height is set to be equal to width for a perfect circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pageNumber == 0
                            ? Color.fromRGBO(139, 32, 141, 1)
                            : Color(0xFFdcdee0),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width:
                          20.0, // Adjust the width to change the size of the circle
                      height:
                          20.0, // Height is set to be equal to width for a perfect circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pageNumber == 1
                            ? Color.fromRGBO(139, 32, 141, 1)
                            : Color(0xFFdcdee0),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width:
                          20.0, // Adjust the width to change the size of the circle
                      height:
                          20.0, // Height is set to be equal to width for a perfect circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pageNumber == 2
                            ? Color.fromRGBO(139, 32, 141, 1)
                            : Color(0xFFdcdee0),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                pageNumber == 2
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(209, 209, 209, 1),
                                  width: 1.0, // Adjust the width of the line as needed
                                ),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Color.fromRGBO(209, 209, 209, 1),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        CustomButton(
                            title: 'start',
                            function: () {
                              if (pageNumber == 2) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              } else {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            }),
                      ],
                    )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(209, 209, 209, 1),
                                  width: 1.0, // Adjust the width of the line as needed
                                ),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Color.fromRGBO(209, 209, 209, 1),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        CustomButton(
                            title: 'Next',
                            function: () {
                              if (pageNumber == 2) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              } else {
                                _pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            }),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
