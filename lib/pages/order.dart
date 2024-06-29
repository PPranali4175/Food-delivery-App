import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodordering/service/database.dart';
import 'package:foodordering/service/shared_pref.dart';

import '../widget/widget_support.dart';
import 'details.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id,wallet;
  int total=0,amount2=0;
  void startTimer(){
    Timer(Duration(seconds: 2),(){
      amount2=total;
      setState(() {

      });
    });
  }

  getthesharedpref()async{
    id= await SharedPrefernceHelper().getUserId();
    wallet=await SharedPrefernceHelper().getUserWallet();
    setState(() {

    });
  }
  ontheload()async{
    await getthesharedpref();
    foodStream=await DatabaseMethods().getFoodCart(id!);
    setState(() {

    });
  }
  void initState(){
    ontheload();
    startTimer();
    super.initState();
  }
  Stream? foodStream;
  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          // Prevent ListView from bouncing
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            total=total+int.parse(ds["Total"]);
            return Container(
              margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
                  child: Row(

                    children: [
                      Container(
                        height: 70,width: 30,
                        decoration:BoxDecoration(border:Border.all(),borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text(ds["Quantity"])),
                      ),
                      SizedBox(width: 20.0,),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(ds["Image"],height: 90,width: 90,fit: BoxFit.cover,)),
                      SizedBox(width: 20.0,),
                      Column(
                        children: [
                          Text(ds["Name"],style: AppWidget.SemiBoldTextFeildStyle(),),

                          Text(ds["Total"]+"Rs",style: AppWidget.SemiBoldTextFeildStyle(),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : CircularProgressIndicator();
      },

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child:Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(child: Text("Food Cart",style: AppWidget.HeadLineTextFeildStyle(),)))
            ),
            SizedBox(height: 20.0,),
            Container(
              height: MediaQuery.of(context).size.height/2,
                child: foodCart()),
            Spacer(),
            Divider(),
            Padding(

              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Price",style: AppWidget.boldTextFeildStyle(),),
                  Text(total.toString()+"Rs",style: AppWidget.SemiBoldTextFeildStyle(),),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: ()async{
                int amount=int.parse(wallet!)-amount2;
                await DatabaseMethods().UpdateUserwallet(id!, amount.toString());
                await SharedPrefernceHelper().saveUserWallet(amount.toString());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.orangeAccent,
                    content: Text("Money deducted",style: TextStyle(fontSize: 18.0),)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 20.0),
                child: Center(child: Text("Checkout",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
