import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodordering/admin/admin_login.dart';
import 'package:foodordering/pages/login.dart';
import 'package:foodordering/service/shared_pref.dart';
import 'package:random_string/random_string.dart';

import '../service/database.dart';
import '../widget/widget_support.dart';
import 'bottomnav.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email="", password="",name="";
  TextEditingController namecontroller=new TextEditingController();

  TextEditingController passwordcontroller=new TextEditingController();

  TextEditingController emailcontroller=new TextEditingController();

  final _formkey=GlobalKey<FormState>();
  
  registration() async{
    if(password!=null){
      try{
        UserCredential userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.redAccent,
            content:Text("Registered successfully",style: TextStyle(fontSize: 20.0),))));
        String Id=randomAlphaNumeric(10);
        Map<String,dynamic> addUserInfo={
          "Name": namecontroller.text,
          "Email": emailcontroller.text,
          "Wallet":"0",
          "Id":Id,
        };
        await DatabaseMethods().addUserDetail(addUserInfo,Id);
        await SharedPrefernceHelper().saveUserName(namecontroller.text);
        await SharedPrefernceHelper().saveUserEmail(emailcontroller.text);
        await SharedPrefernceHelper().saveUserWallet('0');
        await SharedPrefernceHelper().saveUserId(Id);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()));
      }on FirebaseException catch(e){
        if(e.code=='weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text("password provided is too weak",style: TextStyle(fontSize: 18.0),)));
        }
        else if(e.code=="email-aldredy-in-use"){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
              content: Text("Account aldredy exists",style: TextStyle(fontSize: 18.0,),)));
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFff5c30),Color(0xFFe74b1a)])
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
              height: MediaQuery.of(context).size.height/2,
              width:
              MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))

              ),
              child: Text(""),
            ),
            Container(
              margin: EdgeInsets.only(top: 60.0,left: 20.0,right: 20.0),
              child: Column(
                children: [
                  Center(child: Image.asset("images/img_5.png",width: MediaQuery.of(context).size.width/1.5,fit: BoxFit.cover,)),
                  SizedBox(height: 50.0,),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0,right: 20.0,),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/1.7,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            SizedBox(height: 30.0,),
                            Text("Sign Up",style: AppWidget.HeadLineTextFeildStyle(),),
                            SizedBox(height: 30.0,),




                            TextFormField(
                              controller: namecontroller,
                              validator: (value){
                                if(value==null|| value.isEmpty){
                                  return 'Please enter Name';
                                }
                                return null;
                              },

                              decoration: InputDecoration(hintText: 'Name',hintStyle:AppWidget.SemiBoldTextFeildStyle(),prefixIcon: Icon(Icons.person_outline)),
                            ),

                            SizedBox(height: 30.0,),




                            TextFormField(
                              controller: emailcontroller,
                              validator: (value){
                                if(value==null|| value.isEmpty){
                                  return 'Please enter E-mail';
                                }
                                return null;
                              },


                              decoration: InputDecoration(hintText: 'Email',hintStyle:AppWidget.SemiBoldTextFeildStyle(),prefixIcon: Icon(Icons.email_outlined)),
                            ),



                            SizedBox(height: 30.0,),


                            TextFormField(
                              controller: passwordcontroller,
                              validator: (value){
                                if(value==null|| value.isEmpty){
                                  return 'Please enter Password';
                                }
                                return null;
                              },

                              obscureText: true,
                              decoration: InputDecoration(hintText: 'Password',hintStyle:AppWidget.SemiBoldTextFeildStyle(),prefixIcon: Icon(Icons.password_outlined)),
                            ),


                            SizedBox(height: 80.0,),
                            GestureDetector(
                              onTap: () async{
                                if(_formkey.currentState!.validate()){
                                  setState(() {
                                    email=emailcontroller.text;
                                    name=namecontroller.text;
                                    password=passwordcontroller.text;
                                  });
                                }
                                registration();
                              },
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  width: 200,
                                  decoration: BoxDecoration(color: Color(0xffff5722),borderRadius: BorderRadius.circular(20)),
                                  child: Center(child: Text("Sign up",style: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: 'Poppins',fontWeight: FontWeight.bold),)),

                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                      child: Text("Aldredy have an account? Login",style: AppWidget.SemiBoldTextFeildStyle(),)),
                  SizedBox(height: 10.0,),
                   GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLogin()));
                     },
                     child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        width: 200,
                        decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text("Login As Admin",style: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: 'Poppins',fontWeight: FontWeight.bold),)),
                      ),
                     ),
                   ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
