import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shop/routes/login.dart';

class forgotPasswordPage extends StatefulWidget {
  const forgotPasswordPage({super.key});

  @override
  State<forgotPasswordPage> createState() => _forgotPasswordPageState();
}

class _forgotPasswordPageState extends State<forgotPasswordPage> {
  bool loading = false;
  final emailController = TextEditingController();
  String get email => emailController.text.trim();

  Future resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        loading = false;
      });
      Get.snackbar(
            'Sent!',
            'Reset Password Link Sent! Check Your Email.',
            backgroundColor: Colors.greenAccent,
            icon: Icon(Icons.done),
          );
      Get.to(loginPage());
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      Get.snackbar(
            'Failed',
            e.message.toString(),
            backgroundColor: Colors.redAccent,
            icon: Icon(Icons.cancel),
          );
    }
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
                      'Reset Password',
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
                    transform: Matrix4.translationValues(0, -80, 0),
                    child: Image.asset(
                      'assets/resetPassword.png',
                      width: widthScreen * 0.55,
                    ),
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -50, 0),
                    width: widthScreen * 0.75,
                    height: heightScreen * 0.07,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(83, 219, 218, 216),
                        filled: true,
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 133, 132, 130),
                            fontSize: 13,
                            height: 1.75),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    transform: Matrix4.translationValues(0, -50, 0),
                    width: widthScreen * 0.75,
                    height: heightScreen * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        resetPassword(email);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: !loading,
                            child: Text(
                              'Reset Password',
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
