import 'package:flutter/material.dart';
import 'package:recipe_app/widget/support_widget.dart';
class Recipe extends StatefulWidget {
  String image, foodname, recipe;
  Recipe({required this.image, required this.foodname,required this.recipe});

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Image.network(
              widget.image!,
              width: MediaQuery.of(context).size.width,
              height: 400,
              fit: BoxFit.cover,
            ),
            Container(
              padding: EdgeInsets.only(left:20.0,right: 20.0,top: 40.0),
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width/1.1),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))),
            
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Text(widget.foodname,style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                  Divider(),
                  SizedBox(height: 10.0,),
                  Text("About Recipes",style: AppWidget.boldfeildtextstyle(),),
                  SizedBox(height: 10.0,),
                  Text(widget.recipe,style: AppWidget.boldfeildtextstyle(),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
