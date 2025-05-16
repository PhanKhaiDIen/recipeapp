import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{
  Future Addrecipe(Map<String, dynamic> addrecipe) async {
    return await FirebaseFirestore.instance.collection("Recipe").add(addrecipe);
  }
}