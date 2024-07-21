import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/routes/home.dart';
import 'package:get/get.dart';

class passwordPage extends StatefulWidget {
  const passwordPage({super.key});

  @override
  State<passwordPage> createState() => _passwordPageState();
}

class _passwordPageState extends State<passwordPage> {
  bool loading = false;
  final currentPassowrdController = TextEditingController();
  final newPassowrdController = TextEditingController();
  final confirmNewPassowrdController = TextEditingController();
  String get currentPassowrd => currentPassowrdController.text.trim();
  String get newPassowrd => newPassowrdController.text.trim();
  String get confirmNewPassowrd => confirmNewPassowrdController.text.trim();

  Future changePassword(
      String newPassword, String confirmPassword, String currentPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email.toString(), password: currentPassword);
    user.reauthenticateWithCredential(cred).then((value) {
      if (newPassowrd == confirmPassword) {
        setState(() {
          loading = false;
        });
        user!.updatePassword(newPassword).then((value) {
          Get.snackbar(
            'Success',
            'Password Changed Successfully',
            backgroundColor: Colors.greenAccent,
            icon: Icon(Icons.done),
          );
          Get.to(homePage());
        }).catchError((error) {
          Get.snackbar(
            'Failed',
            error.toString(),
            backgroundColor: Colors.redAccent,
            icon: Icon(Icons.cancel),
          );
        });
      } else {
        setState(() {
          loading = false;
        });
        Get.snackbar(
          'Invalid Password',
          'confirm password has a contradiction with new password',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.cancel),
        );
      }
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
        'Wrong Password',
        error.message,
        backgroundColor: Colors.redAccent,
        icon: Icon(Icons.cancel),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 249, 249, 248),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: heightScreen * 0.15,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 85, 131, 249),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change Password',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
              width: double.infinity,
              height: heightScreen * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    transform: Matrix4.translationValues(0, -20, 0),
                    child: Image.asset(
                      'assets/changePassword.png',
                      width: widthScreen * 0.35,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  textFields(
                    widthScreen: widthScreen,
                    heightScreen: heightScreen,
                    text: 'Current Password',
                    controller: currentPassowrdController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  textFields(
                    widthScreen: widthScreen,
                    heightScreen: heightScreen,
                    text: 'New Password',
                    controller: newPassowrdController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  textFields(
                    widthScreen: widthScreen,
                    heightScreen: heightScreen,
                    text: 'Confirm New Password',
                    controller: confirmNewPassowrdController,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: widthScreen * 0.75,
                    height: heightScreen * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        changePassword(
                            newPassowrd, confirmNewPassowrd, currentPassowrd);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: !loading,
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: loading,
                            child: Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11)),
                      ),
                    ),
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

class textFields extends StatelessWidget {
  final double widthScreen;
  final double heightScreen;
  final String text;
  final TextEditingController controller;

  const textFields({
    super.key,
    required this.widthScreen,
    required this.heightScreen,
    required this.text,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthScreen * 0.75,
      height: heightScreen * 0.07,
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          fillColor: Color.fromARGB(83, 219, 218, 216),
          filled: true,
          hintText: text,
          hintStyle: TextStyle(
              color: Color.fromARGB(255, 133, 132, 130),
              fontSize: 13,
              height: 1.75),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
