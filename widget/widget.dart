import 'package:flutter/cupertino.dart';

Widget CustomButton({
  required String title,
  required var function,
}){
  return GestureDetector(
    onTap: function,
    child: Container(
      width: 128,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromRGBO(189, 106, 197, 0.54),
        border: Border.all(
          color: Color.fromRGBO(139, 32, 141, 1), // Change this color to the color you desire for the border
          width: 2, // Adjust the width of the border as needed
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(209, 209, 209, 1),
          ),
        ),
      ),
    ),
  );
}
