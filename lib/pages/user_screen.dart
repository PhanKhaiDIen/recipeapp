import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Login_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String name = "", birth = "", phone = "", email = "", address = "";
  File? avatarFile;
  String? avatarUrl;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      var doc = await FirebaseFirestore.instance.collection('User_information').doc(uid).get();
      if (doc.exists) {
        var data = doc.data()!;
        setState(() {
          name = data['name'] ?? "";
          birth = data['birth'] ?? "";
          phone = data['phone'] ?? "";
          email = data['email'] ?? "";
          address = data['address'] ?? "";
          avatarUrl = data['avatarUrl'];
        });
      }
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void navigateToEdit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          name: name,
          birth: birth,
          phone: phone,
          email: email,
          address: address,
        ),
      ),
    );
    loadUserData(); // reload sau khi chỉnh sửa
  }

  Future<void> pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        avatarFile = imageFile;
      });

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // Upload lên Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child("avatars/$uid.jpg");
        await storageRef.putFile(avatarFile!);
        String downloadUrl = await storageRef.getDownloadURL();


        // Lấy URL ảnh
        final imageUrl = await storageRef.getDownloadURL();

        // Lưu vào Firestore
        await FirebaseFirestore.instance.collection('User_information').doc(uid).update({
          'avatarUrl': imageUrl,
        });

        print("Avatar updated: $imageUrl");
      }
    }
  }


  Widget buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text("$label: $value", style: const TextStyle(fontSize: 14)),
    );
  }

  Widget buildMenuItem(String title, VoidCallback? onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hồ Sơ Người Dùng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: pickAvatar,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: avatarFile != null
                          ? FileImage(avatarFile!)
                          : (avatarUrl != null ? NetworkImage(avatarUrl!) : null) as ImageProvider?,
                      child: (avatarFile == null && avatarUrl == null)
                          ? const Icon(Icons.add_a_photo, size: 40, color: Colors.black)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInfoItem("Họ và tên", name),
                        buildInfoItem("Ngày sinh", birth),
                        buildInfoItem("Số điện thoại", phone),
                        buildInfoItem("Email", email),
                        buildInfoItem("Địa chỉ", address),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildMenuItem("Thông tin cá nhân", navigateToEdit),
            buildMenuItem("Công thức yêu thích", () {}),
            buildMenuItem("Câu hỏi thường gặp", () {}),
            buildMenuItem("Quyên góp từ thiện", () {}),
            const Spacer(),
            ElevatedButton(
              onPressed: logOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Log Out", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}


class EditProfileScreen extends StatefulWidget {
  final String name, birth, phone, email, address;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.birth,
    required this.phone,
    required this.email,
    required this.address,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController,
      birthController,
      phoneController,
      emailController,
      addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    birthController = TextEditingController(text: widget.birth);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    addressController = TextEditingController(text: widget.address);
  }

  Future<void> updateUserData() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('User_information').doc(uid).set({
        'name': nameController.text,
        'birth': birthController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'address': addressController.text,
      });
      Navigator.pop(context);
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin cá nhân")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Họ và tên", nameController),
              buildTextField("Ngày sinh", birthController),
              buildTextField("Số điện thoại", phoneController),
              buildTextField("Email", emailController),
              buildTextField("Địa chỉ", addressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateUserData,
                child: const Text("Cập nhật thông tin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
