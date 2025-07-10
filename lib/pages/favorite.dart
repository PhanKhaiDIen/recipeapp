import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/services/database.dart';
import 'package:recipe_app/pages/recipe.dart'; // nếu bạn muốn mở lại trang món ăn

class FavoritePage extends StatelessWidget {
  final DatabaseMethods db = DatabaseMethods();

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Công thức món ăn yêu thích")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Favorites")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Bạn chưa yêu thích công thức món nào."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return ListTile(
                leading: Image.network(
                  data['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(data['foodname']),
                subtitle: Text(
                  data['recipe'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Recipe(
                        image: data['image'],
                        foodname: data['foodname'],
                        recipe: data['recipe'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
