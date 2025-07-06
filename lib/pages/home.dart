import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/pages/add_recipe.dart';
import 'package:recipe_app/pages/category.dart';
import 'package:recipe_app/pages/recipe.dart';
import 'package:recipe_app/services/database.dart';
import 'package:recipe_app/widget/support_widget.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   Stream? recipeStream;

  getontheload()async{
    recipeStream= await DatabaseMethods().getallRecipe();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  bool search=false;

  var queryResultSet=[];
  var tempSearchStore=[];

  initiateSearch(value){
    if(value.length==0){
      setState(() {

        queryResultSet=[];
        tempSearchStore=[];
        search=false;
      });
      return;
    }
    setState(() {
      search=true;
    });
    var capitalizedValue=value.substring(0,1).toUpperCase()+ value.substring(1);
    if(queryResultSet.isEmpty &&value.length==1){
      setState(() {
        queryResultSet=[];
        DatabaseMethods().Search(value).then((QuerySnapshot docs){
          for(int i=0;i<docs.docs.length;++i){
            queryResultSet.add(docs.docs[i].data());
          }
        } );
      });;
    }else{
      tempSearchStore=[];
      queryResultSet.forEach((element){
        if(element['SearchedName'].startsWith(capitalizedValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

Widget allRecipe(){
  return StreamBuilder(stream: recipeStream, builder: (context,AsyncSnapshot snapshot){
    return snapshot.hasData?
        ListView.builder(
            padding:EdgeInsets.zero,
            itemCount:snapshot.data.docs.length,
            scrollDirection:Axis.horizontal ,
            itemBuilder: (context, index){
              DocumentSnapshot ds=snapshot.data.docs[index];
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Recipe(image: ds["Image"], foodname:ds["Name"], recipe: ds["Detail"])));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:BorderRadius.circular(10),
                        child:Image.network(
                          ds["Image"],
                          height: 300,
                          width: 250,
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
              );
            })
        :Container();
  }
  );
}

  @override
  Widget build (BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddRecipe()),
          );
        },child: Icon(Icons.add,color: Colors.white,), ),
      body: Container(
        margin: EdgeInsets.only(top: 50.0,left: 20.0),
        child: Column(
          children: [
            Padding(
              padding:const EdgeInsets.only(right: 20.0),
              child:Row(
                children: [
                  Text(
                    "Looking for your\nfavourite meal",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Spacer(),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:Image.asset(
                          "images/obito.jpg",
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover
                      )
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              margin: EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(color: Color.fromARGB(225,226,226,236),borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                onChanged: (value){
                  initiateSearch(value.toUpperCase());
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.search_outlined),
                        hintText:"Search Recipe...",
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            search? ListView(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element){
                return buildResultCard(element);
              }).toList()
            )
            :Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Expanded(
                    child:ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> CategoryRecipe(category: "Com Tam Recipes")));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius:BorderRadius.circular(10),
                                  child: Image.asset(
                                    "images/comtam.jpg",
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Text("Com Tam Recipes",
                                    style: AppWidget.lightfeildtextstyle()
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> CategoryRecipe(category: "Pho Recipes")));
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 20.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius:BorderRadius.circular(10),
                                  child: Image.asset(
                                    "images/pho.jpg",
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Text("Pho Recipes",
                                    style: AppWidget.lightfeildtextstyle()
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius:BorderRadius.circular(10),
                                child: Image.asset(
                                  "images/bunbo.jpg",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text("Bun Bo Recipes",
                                  style: AppWidget.lightfeildtextstyle()
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius:BorderRadius.circular(10),
                                child: Image.asset(
                                  "images/banhxeo.jpg",
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Text("Banh Xeo Recipes",
                                  style: AppWidget.lightfeildtextstyle()
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0,
                ),
            search? Container(): Expanded(child: allRecipe()),


          ],
        ),
      ),
    );
  }
  Widget buildResultCard(data){
    return  GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>Recipe(image: data['Image'], foodname: data['Name'], recipe: data['Detail'])));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(data['Image'],height: 70,width: 70,fit: BoxFit.cover),
                ),
                SizedBox(width: 20.0,),
                Text(data ['Name'],style: AppWidget.boldfeildtextstyle(),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

