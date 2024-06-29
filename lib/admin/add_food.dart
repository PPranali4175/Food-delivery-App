

import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodordering/service/database.dart';
import 'package:foodordering/widget/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String>items=['Ice-cream','Burger','Salad','Pizza'];
  String? value;
  TextEditingController namecontroller=new TextEditingController();
  TextEditingController pricecontroller=new TextEditingController();
  TextEditingController detailcontroller=new TextEditingController();
  final ImagePicker _picker=ImagePicker();
  File? selectedImage;
  Future getImage()async{
    var image=await _picker.pickImage(source: ImageSource.gallery);
    selectedImage=File(image!.path);
    setState(() {

    });
  }
  uploadItem()async{
    if(selectedImage!=null&& namecontroller.text!=""&& pricecontroller.text!=""&& detailcontroller.text!=""){
      String addId=randomAlphaNumeric(10);
      Reference firebaseStorageRef=FirebaseStorage.instance.ref().child("blogImages").child(addId);
      final UploadTask task=firebaseStorageRef.putFile(selectedImage!);

      var downloadUrl= await(await task).ref.getDownloadURL();
      Map<String,dynamic> addItem={
        "Image":downloadUrl,
        "Name":namecontroller.text,
        "price":pricecontroller.text,
        "Detail":detailcontroller.text,
      };
      await DatabaseMethods().addFoodItem(addItem, value!).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text("food Item has been added successfully",style: TextStyle(fontSize: 18.0),)));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap:(){
              Navigator.pop(context);
            },child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF373866),)),
        centerTitle: true,
        title: Text("Add Item",style: AppWidget.HeadLineTextFeildStyle(),),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin:EdgeInsets.only(left:20.0,right:20.0,top:20.0,bottom:20.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
                 Text("upload the item picture",style: AppWidget.SemiBoldTextFeildStyle(),),
              SizedBox(height: 20.0,),
              selectedImage==null? GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Material(
                    elevation: 4.0,
                      borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border:Border.all(color: Colors.black,width: 1.5,),borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.camera_alt_outlined,color: Colors.black,),
                    ),
                  ),
                ),
              ):Center(
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border:Border.all(color: Colors.black,width: 1.5,),borderRadius: BorderRadius.circular(20),
                    ),
                    child:ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0,),
              Text("Item Name",style: AppWidget.SemiBoldTextFeildStyle(),),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xFFececf8),
                borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Enter item name",hintStyle: AppWidget.LightTextFeildStyle()),
                ),

              ),
              SizedBox(height: 30.0,),
              Text("Item price",style: AppWidget.SemiBoldTextFeildStyle(),),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: pricecontroller,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Enter item price",hintStyle: AppWidget.LightTextFeildStyle()),
                ),

              ),
              SizedBox(height: 30.0,),
              Text("Item Detail",style: AppWidget.SemiBoldTextFeildStyle(),),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  maxLines: 6,
                  controller: detailcontroller,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Enter item detail",hintStyle: AppWidget.LightTextFeildStyle()),
                ),

              ),
              SizedBox(height: 20.0,),
              Text("Select Category",style: AppWidget.SemiBoldTextFeildStyle(),),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Color(0xFFececf8),borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(child: DropdownButton<String>(items: items.map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,style: TextStyle(fontSize: 18.0,color: Colors.black),))).toList(),
                  onChanged:((value)=>setState(() {
                  this.value=value;
                })) ,dropdownColor: Colors.white,hint: Text("Select Category"),iconSize: 36,icon: Icon(Icons.arrow_drop_down,color: Colors.black,),value: value,)),
              ),
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: (){
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      width: 150,
                      decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10),),
                      child: Center(child: Text("Add",style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
