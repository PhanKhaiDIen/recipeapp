import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/recipe.dart';
import 'package:recipe_app/services/database.dart';
import 'package:recipe_app/widget/support_widget.dart';

class CategoryRecipe extends StatefulWidget {
  String category;
  CategoryRecipe({required this.category});

  @override
  State<CategoryRecipe> createState() => _CategoryRecipeState();
}

class _CategoryRecipeState extends State<CategoryRecipe> {

Stream? categoryStream;
getontheload()async{
  categoryStream= await DatabaseMethods().getCategoryRecipe(widget.category);
  setState(() {

  });
}

@override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allRecipe(){
    return StreamBuilder(stream: categoryStream, builder: (context, AsyncSnapshot snapshot){
      return snapshot.hasData
          ? GridView.builder(
              padding:EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0
              ),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                DocumentSnapshot ds=snapshot.data.docs[index];
             return GestureDetector(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Recipe(image: ds["Image"], foodname:ds["Name"], recipe: ds["Detail"])));
               },
               child: Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     ClipRRect(
                         borderRadius:BorderRadius.circular(10),
                         child:Image.network(
                           ds["Image"],
                           height: 220,
                           fit: BoxFit.cover,
                         )),
                     SizedBox(
                       height: 10.0,
                     ),
                     Text(
                       ds["Name"],
                       style: AppWidget.boldfeildtextstyle(),
                     )
                   ],
                 ),
               ),
             ); })
          : Container();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0,left: 20.0,right: 20.0),
        child: Column(children: [
          Center(
            child: Text(
              widget.category,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 20.0,),
          Expanded(child: allRecipe())
      ],),),
    );
  }
}
