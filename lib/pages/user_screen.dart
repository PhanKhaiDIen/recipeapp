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
          avatarUrl: avatarUrl,
        ),
      ),
    );
    loadUserData();
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
      appBar: AppBar(title: const Text("Hồ Sơ Người Dùng"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null ? const Icon(Icons.add_a_photo, size: 30, color: Colors.black) : null,
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
            const SizedBox(height: 10),
            buildMenuItem("Thông tin cá nhân", navigateToEdit),
            const SizedBox(height: 10),
            buildMenuItem("Công thức yêu thích", () {}),
            const SizedBox(height: 10),
            buildMenuItem("Câu hỏi thường gặp", () {}),
            const SizedBox(height: 10),
            buildMenuItem("Quyên góp từ thiện", () {}),
            const Spacer(),
            ElevatedButton(
              onPressed: logOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                minimumSize: const Size.fromHeight(60),
              ),
              child: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Edit Profile --------------------------

class EditProfileScreen extends StatefulWidget {
  final String name, birth, phone, email, address;
  final String? avatarUrl;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.birth,
    required this.phone,
    required this.email,
    required this.address,
    this.avatarUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  String? imageUrl;

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
    imageUrl = widget.avatarUrl;
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() {
        _pickedImage = image;
      });

      final url = await uploadAvatar(image);
      if (url != null) {
        setState(() {
          imageUrl = url;
        });
      }
    }
  }

  Future<String?> uploadAvatar(File imageFile) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final ref = FirebaseStorage.instance.ref().child("avatars/$uid.jpg");
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    }
    return null;
  }

  Future<void> updateUserData() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    Map<String, dynamic> updatedData = {
      'name': nameController.text,
      'birth': birthController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
    };

    if (imageUrl != null) {
      updatedData['avatarUrl'] = imageUrl;
    }

    await FirebaseFirestore.instance
        .collection('User_information')
        .doc(uid)
        .set(updatedData);

    Navigator.pop(context);
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (imageUrl != null ? NetworkImage(imageUrl!) : null) as ImageProvider?,
                        child: _pickedImage == null && imageUrl == null
                            ? const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.black)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextField("Họ và tên", nameController),
                          const SizedBox(height: 10),
                          buildTextField("Ngày tháng năm sinh", birthController),
                          const SizedBox(height: 10),
                          buildTextField("Số điện thoại", phoneController),
                          const SizedBox(height: 10),
                          buildTextField("Email người dùng", emailController),
                          const SizedBox(height: 10),
                          buildTextField("Địa chỉ nhà", addressController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Cập nhật thông tin", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
