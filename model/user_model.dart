// class _SalesData {
//   _SalesData(this.year, this.sales);
//   final String year;
//   final double sales;
// }
class UserModel{

  late var userId,email, password,name , kidName , gender,image;


  UserModel({
    required this.userId,
    required this.email,
    required this.password,
    this.name,
    this.kidName='',
    this.gender='',
    this.image
  });

  UserModel.fromJson(Map<dynamic,dynamic>map){
    if(map == null){
      return;
    }
    userId = map['userId'];  //map['userId'] data get from fire store

    email=map['emil'];
    password=map['password'];

    name=map['name'];
    kidName=map['kidName'];
    gender=map['gender'];
    image=map['image'];


  }


  //anther form
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['num1'] = this.num1;
  //   data['num2'] = this.num2;
  //   return data;
  // }

  toMap(){
    return {
      'userId': userId,
      'emil' : email,
      'password':password,
      'name':name,
      'kidName':kidName,
      'gender':gender,
      'image':image
    };
  }





}