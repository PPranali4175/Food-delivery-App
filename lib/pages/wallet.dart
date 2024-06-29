import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:foodordering/service/database.dart';
import 'package:foodordering/service/shared_pref.dart';
import 'package:foodordering/widget/app_constant.dart';
import 'package:foodordering/widget/widget_support.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;
  int? add;
  TextEditingController amountcontroller=new TextEditingController();
  getthesharedpref()async{
    wallet=await SharedPrefernceHelper().getUserWallet();
    id=await SharedPrefernceHelper().getUserId();
    setState(() {

    });
  }
  ontheload()async{
    await getthesharedpref();
    setState(() {

    });
  }
  void initState(){
    ontheload();
    super.initState();
  }
   Map<String,dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet==null? CircularProgressIndicator(): Container(
        margin: EdgeInsets.only(top:50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
                child:Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(child: Text("wallet",style: AppWidget.HeadLineTextFeildStyle(),)))
                ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color:Color(0xFFF2F2F2)),
              child: Row(
                children: [
                  Image.asset("images/img_6.png",height: 60,width: 60,fit: BoxFit.cover,),
                  SizedBox(width: 40.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("your wallet",style: AppWidget.SemiBoldTextFeildStyle(),),
                      SizedBox(height: 5.0,),
                      Text("Rs"+wallet!,style: AppWidget.boldTextFeildStyle(),)
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Add money",style: AppWidget.SemiBoldTextFeildStyle(),),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    makePayment('100');
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border:Border.all(color: Color(0xFFE9E2E2)),
                      borderRadius: BorderRadius.circular(5)),
                    child: Text("Rs"+"100",style: AppWidget.SemiBoldTextFeildStyle(),),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      makePayment('500');
                    },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border:Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text("Rs"+"500",style: AppWidget.SemiBoldTextFeildStyle(),),
                  ),
                ),
                GestureDetector(
                  onTap: (){

                      makePayment('1000');

                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border:Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text("Rs"+"1000",style: AppWidget.SemiBoldTextFeildStyle(),),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      makePayment('2000');
                    },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border:Border.all(color: Color(0xFFE9E2E2)),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text("Rs"+"2000",style: AppWidget.SemiBoldTextFeildStyle(),),
                  ),
                )
              ],
            ),
            SizedBox(height: 50.0,),
            GestureDetector(
              onTap: (){
                openEdit();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0,),
                padding: EdgeInsets.symmetric(vertical: 12.0,),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Center(
                  child: Text("Add money",style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: 'Poppins',fontWeight: FontWeight.bold),),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
  Future<void> makePayment(String amount) async{
    try{
      paymentIntent=await createPaymentIntent(amount,'INR');
      await Stripe.instance.initPaymentSheet(paymentSheetParameters:SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: 'Adnan'
      )).then((value) {});

      displayPaymentSheet(amount);
    }catch(e,s){
      print('exception: $e$s');
    }
  }
  displayPaymentSheet(String amount) async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        add=int.parse(wallet!)+int.parse(amount);
        await SharedPrefernceHelper().saveUserWallet(add.toString());
        await DatabaseMethods().UpdateUserwallet(id!,add.toString());
        showDialog(context: context, builder: (_)=>AlertDialog(
          content: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle,color: Colors.green,),Text("Payment Successful"),
                ],
              )
            ],
          ),
        ));
        await getthesharedpref();

        paymentIntent=null;

      }).onError((error, stackTrace){
        print('Error is:---> $error $stackTrace');
      });
    }on StripeException catch(e){
      print('Error is---> $e');
      showDialog(context: context, builder: (_)=> const AlertDialog(
        content: Text("cancelled"),
      ));
    }catch(e){
      print('$e');
    }
  }

  createPaymentIntent(String amount,String currency) async {
    try{
      Map<String,dynamic> body={
        'amount':calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card',
      };
      var response=await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':'Bearer $secretkey',
          'Content-Type':'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('PaymentIntent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    }catch(err){
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount){
    final calculatedAmount=(int.parse(amount)*100);

    return calculatedAmount.toString();
  }
  Future openEdit()=>showDialog(context: context, builder: (context)=>AlertDialog(
    content: SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: Icon(Icons.cancel)),
                SizedBox(width: 60.0,),
                Center(
                  child: Text("Add Money",style: TextStyle(color: Color(0xFF008080),
                    fontWeight: FontWeight.bold,
                  ),),
                )
              ],
            ),
            SizedBox(height: 20.0,),
            Text("Amount"),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(border:Border.all(color: Colors.black38,width: 2.0),borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller:amountcontroller ,
                decoration: InputDecoration(border: InputBorder.none,hintText: 'Enter Amount'),
              ),
            ),
            SizedBox(height: 20.0,),
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  makePayment(amountcontroller.text);
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.all(5),

                  decoration: BoxDecoration(color: Color(0xFF008080),borderRadius: BorderRadius.circular(10),),child: Center(child: Text("Pay",style: TextStyle(color: Colors.white),)),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ));
}
