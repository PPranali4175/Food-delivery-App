import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodordering/pages/details.dart';
import 'package:foodordering/service/database.dart';
import 'package:foodordering/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream=false,pizza=false,burger=false,salad=false;

  Stream? fooditemStream;
  ontheload()async{
    fooditemStream=await DatabaseMethods().getFoodItem("Ice-cream");
    setState(() {

    });
  }
  @override
  void initState(){
    ontheload();
    super.initState();
  }
  Widget allItemsVertically() {
    return StreamBuilder(
        stream: fooditemStream,
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Details(detail: ds["Detail"],name: ds["Name"],price: ds["price"],image: ds["Image"],)),
                  );
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: EdgeInsets.only(right: 20.0, bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  ds["Image"],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10.0,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds["Name"],
                                      style: AppWidget.SemiBoldTextFeildStyle(),
                                    ),
                                    SizedBox(height: 3.0,),
                                    Text(
                                      "honey goot cheese",
                                      style: AppWidget.LightTextFeildStyle(),
                                    ),
                                    SizedBox(height: 3.0,),
                                    Text(
                                      ds["price"]+"Rs",
                                      style: AppWidget.SemiBoldTextFeildStyle(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
  Widget allItems(){

    return StreamBuilder( stream: fooditemStream,builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
        DocumentSnapshot ds=snapshot.data.docs[index];
        return   GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Details(detail: ds["Detail"],name: ds["Name"],price: ds["price"],image: ds["Image"],)));
          },

            child: Container(
              margin:EdgeInsets.all(5),

              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(ds["Image"],height: 150,width: 150,fit: BoxFit.cover,)),
                      Text(ds["Name"],style: AppWidget.SemiBoldTextFeildStyle()),
                      SizedBox(height: 5.0,),
                      Text("Fresh and healthy",style: AppWidget.LightTextFeildStyle(),),
                      SizedBox(height: 5.0,),
                      Text(ds["price"]+"Rs",style: AppWidget.SemiBoldTextFeildStyle(),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }):CircularProgressIndicator();
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.only(top: 50.0,left: 20.0,right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("hello Pranali",style: AppWidget.boldTextFeildStyle()
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.shopping_cart,color: Colors.white,),
                  )
                ],
              ),
              SizedBox(height: 20.0,),
              Text("Delicious food",style: AppWidget.HeadLineTextFeildStyle()
              ),

              Text("Discover and get great food",style: AppWidget.LightTextFeildStyle(),
              ),
              SizedBox(height: 20.0,),
              showItem(),
              SizedBox(height: 30.0,),

                  Container(
                   height: 260,
                    child:allItems()),

        SizedBox(height: 30.0,),
              SingleChildScrollView(
                child: Container(
                  height: 200,
                  child:allItemsVertically(),),
              )
              

            ],
          ),
        ),
      ),
    );
  }
  Widget showItem(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: ()async{
            icecream=true;
            pizza=false;
            burger=false;
            salad=false;
            ontheload();
            setState(() {

            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: icecream?Colors.black:Colors.white,borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/ice_cream.jpg",height: 50,width: 50,fit: BoxFit.cover,),
            ),
          ),
        ),
        GestureDetector(
          onTap: ()async{
            icecream=false;
            pizza=true;
            burger=false;
            salad=false;
            fooditemStream=await DatabaseMethods().getFoodItem("Pizza");
            setState(() {

            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: pizza?Colors.black:Colors.white,borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/pizza.jpg",height: 50,width: 50,fit: BoxFit.cover,),
            ),
          ),
        ),
        GestureDetector(
          onTap: ()async{
            icecream=false;
            pizza=false;
            burger=true;
            salad=false;
            fooditemStream=await DatabaseMethods().getFoodItem("Burger");
            setState(() {

            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: burger?Colors.black:Colors.white,borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/burger.jpg",height: 50,width: 50,fit: BoxFit.cover,),
            ),
          ),
        ),
        GestureDetector(
          onTap: ()async{
            icecream=false;
            pizza=false;
            burger=false;
            salad=true;
            fooditemStream=await DatabaseMethods().getFoodItem("Salad");
            setState(() {

            });
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(color: salad?Colors.black:Colors.white,borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.all(8),
              child: Image.asset("images/salad.jpg",height: 50,width: 50,fit: BoxFit.cover,),
            ),
          ),
        ),
      ],
    );
  }
}
