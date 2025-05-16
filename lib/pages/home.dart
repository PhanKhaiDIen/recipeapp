import 'package:flutter/material.dart';
import 'package:recipe_app/widget/support_widget.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build (BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){},child: Icon(Icons.add,color: Colors.white,), ),
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
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(
                        Icons.search_outlined),
                        hintText:"Search Recipe...",
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Expanded(
                child:ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
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
                    Container(
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
          SizedBox(height: 20.0,),
            Expanded(
                child:ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius:BorderRadius.circular(10),
                              child:Image.asset(
                                "images/beefsteak.jpg",
                                height: 300,
                                width: 250,
                                fit: BoxFit.cover,
                              )
                          ),
                          SizedBox(height: 10.0,),
                          Text("Medium BeefSteak",style: AppWidget.boldfeildtextstyle(),)
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius:BorderRadius.circular(10),
                              child:Image.asset(
                                "images/pizza.jpg",
                                height: 300,
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                          ),
                          SizedBox(height: 10.0,),
                          Text("Sausage Pizza",style: AppWidget.boldfeildtextstyle(),)
                        ],
                      ),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

