import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';
class AppMainScreen extends StatefulWidget{
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen>{
  @override
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconSize: 28,
        selectedItemColor: kprimaryColor,
        unselectedItemColor: Colors.grey,
        type:BottomNavigationBarType.fixed ,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                  Iconsax.home5,
              ),
              label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.heart5,
            ),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.calendar5,
            ),
            label: "Meal Plan",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.setting_21,
            ),
            label: "Setting",
          ),
        ],
      ),
    );
  }
}
