import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<void> addToFavorites({required String foodName, required String image, required String recipe,}) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Favorites").doc(foodName)
        .set({
      'foodname': foodName,
      'image': image,
      'recipe': recipe,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  Future<bool> isFavorite(String foodName) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Favorites")
        .doc(foodName)
        .get();

    return doc.exists;
  }
  Future<Stream<QuerySnapshot>> getFavorites() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Favorites")
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  Future<void> removeFromFavorites(String foodName) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("Favorites")
        .doc(foodName)
        .delete();
  }
}
