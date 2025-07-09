import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseMethods{
  Future Addrecipe(Map<String, dynamic> addrecipe) async {
    return await FirebaseFirestore.instance.collection("Recipe").add(addrecipe);
  }
  Future<Stream<QuerySnapshot>> getallRecipe()async{
    return await FirebaseFirestore.instance.collection("Recipe").snapshots();
  }
  Future<Stream<QuerySnapshot>> getCategoryRecipe(String category) async{
    return await FirebaseFirestore.instance.collection("Recipe").where("Category", isEqualTo: category).snapshots();
  }
  Future<QuerySnapshot> Search(String name)async{
    return await FirebaseFirestore.instance.collection("Recipe").where("Key",isEqualTo: name.substring(0,1).toUpperCase()).get();
  }
  Future <void> addUserInfo(String uid,Map<String, dynamic>userInfo)async{
    return await FirebaseFirestore.instance.collection("Users").doc(uid).set(userInfo);
  }
  Future <DocumentSnapshot>getUserInfo(String uid)async{
    return await FirebaseFirestore.instance.collection("Users").doc(uid).get();
  }
    Future<void> addUserProfileInfo(String uid, Map<String, dynamic> userProfile) async {
    return await FirebaseFirestore.instance.collection("User_information").doc(uid).set(userProfile);
  }

  Future<DocumentSnapshot> getUserProfileInfo(String uid) async {
    return await FirebaseFirestore.instance.collection("User_information").doc(uid).get();
  }
  Future<String?> getAvatarUrl(String uid) async {
    final doc = await FirebaseFirestore.instance.collection("User_information").doc(uid).get();
    if (doc.exists) {
      return doc.data()?['avatarUrl'];
    }
    return null;
  }
}
