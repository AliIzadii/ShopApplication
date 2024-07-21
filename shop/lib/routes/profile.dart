import 'dart:io';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fb_storage;
import 'package:path/path.dart';
import 'package:shop/routes/login.dart';
import 'package:shop/routes/password.dart';
import 'package:shop/routes/support.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  File? image;
  profileImage() {
    var imageUrl = FirebaseAuth.instance.currentUser!.photoURL;

    if (imageUrl != null)
      return NetworkImage(imageUrl);
    else if (image != null)
      return FileImage(image!);
    else
      return AssetImage('assets/account.jpg');
  }

  Future uploadImage() async {
    if (image == null) return;
    final imageName = basename(image!.path);
    final destination = 'files/$imageName';

    try {
      final ref =
          fb_storage.FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(image!);
      var imageUrl = await ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
    } catch (e) {}
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imagePath = File(image.path);
      setState(() {
        this.image = imagePath;
        uploadImage();
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 249, 248),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: heightScreen * 0.4,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 85, 131, 249),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Profile',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Container(
                            width: 100,
                            height: 35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Edit Profile',
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(169, 237, 237, 235),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Expanded(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: profileImage(), fit: BoxFit.cover),
                        ),
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                                onTap: () {
                                  pickImage();
                                },
                                child: Image.asset(
                                  'assets/add.png',
                                  width: 22,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName.toString(),
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            Container(
              width: double.infinity,
              height: heightScreen * 0.55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  option(
                    text: 'Password',
                    icon: Icons.lock_open,
                    func: () {
                      Get.to(passwordPage());
                    },
                  ),
                  option(
                    text: 'Support',
                    icon: Icons.call_rounded,
                    func: () {
                      Get.to(supportPage());
                    },
                  ),
                  option(
                    text: 'Sign Out',
                    icon: Icons.logout,
                    func: () {
                      FirebaseAuth.instance.signOut();
                      Get.offAll(loginPage());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class option extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? func;
  const option({
    required this.text,
    required this.icon,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Container(
        width: widthScreen * 0.8,
        height: 55,
        decoration: BoxDecoration(
          color: Color.fromARGB(194, 233, 232, 231),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blue[600]),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                ],
              ),
              IconButton(
                  onPressed: func,
                  icon: Icon(Icons.arrow_forward, color: Colors.blue[600])),
            ],
          ),
        ),
      ),
    );
  }
}
