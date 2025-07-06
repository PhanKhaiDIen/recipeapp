import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/widget/support_widget.dart';
import 'package:random_string/random_string.dart';
import 'package:recipe_app/services/database.dart';


class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  String? value;
  final List<String> recipe=['Com Tam Recipes','Pho Recipes','Bun Bo Recipes','Banh Xeo Recipes'];
  File? selectedImage;
  TextEditingController namecontroller=new TextEditingController();
  TextEditingController detailcontroller=new TextEditingController();

final ImagePicker _picker= ImagePicker();

Future getImage()async{
  var image= await _picker.pickImage(source: ImageSource.gallery);
  selectedImage=File(image!.path);
  setState(() {

  });
}

uploadItem()async{
  if(selectedImage!=null && namecontroller.text!="" && detailcontroller.text!=""){
    String addId = randomAlphaNumeric(10);

    Reference firebaseStorageRef=FirebaseStorage.instance.ref().child("blogImage").child(addId);

    final UploadTask task= firebaseStorageRef.putFile(selectedImage!);
    var downloadurl= await(await task).ref.getDownloadURL();

    Map<String, dynamic> addrecipe={
      "Name":namecontroller.text,
      "Detail":detailcontroller.text,
      "Image": downloadurl,
      "Category": value,
      "Key":namecontroller.text.substring(0,1).toUpperCase(),
      "SearchedName": namecontroller.text.toUpperCase()
    };
    DatabaseMethods().Addrecipe(addrecipe).then((value){
      Fluttertoast.showToast(
          msg: "Recipe has been added Successfully <3",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      namecontroller.text="";
      detailcontroller.text="";
      selectedImage=null;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0,left: 20.0,right: 20.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Recipe",style:TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 20.0,),
              selectedImage!=null?GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(selectedImage!,fit: BoxFit.cover)),
                  ),
                ),
              ) : GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all()),
                    child: const Center(
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
        
              SizedBox(height: 20.0,),
              Text("Recipe Name",style: AppWidget.boldfeildtextstyle(),),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white,border: Border.all(),borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,hintText: "Write a Recipe Name"),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(20),border: Border.all()
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      items: recipe
                          .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 18.0, color: Colors.black),
                            )))
                          .toList(),
                          onChanged:((value)=> setState(() {
                            this.value=value;
                          })),
                          dropdownColor: Colors.white,
                          hint: Text("Select Category"),
                          iconSize: 36,
                          icon: Icon(Icons.arrow_drop_down,color: Colors.black,),
                          value: value,),

                ),
              ),
              SizedBox(height: 20.0,),
              Text(
                "Recipe Details",
                style: AppWidget.boldfeildtextstyle(),),
              SizedBox(height: 10.0,),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white,border: Border.all(),borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: detailcontroller,
                  maxLines: 10,
                  decoration: InputDecoration(border: InputBorder.none,hintText: "Write a Recipe Details"),
                ),
              ),
              SizedBox(height: 20.0,),
              GestureDetector(
                onTap: (){
                  uploadItem();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 8.5,bottom: 8.5),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
