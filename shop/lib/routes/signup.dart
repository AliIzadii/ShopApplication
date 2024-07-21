import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:shop/routes/forgotPassword.dart';
import 'package:shop/routes/home.dart';
import 'package:shop/routes/login.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  bool? val = false;
  void signUp(String email, String password, String name) async {
    try {
      var result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = result.user;
      user?.updateDisplayName(name);
      if (FirebaseAuth.instance.currentUser!.email != null) {
        Get.offAll(homePage());
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      if (e.code == "unknown") {
        Get.snackbar(
          'Unknown',
          '${e.message}',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.cancel),
        );
      } else if (e.code == "invalid-email") {
        Get.snackbar(
          'Invalid Email',
          '${e.message}',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.cancel),
        );
      } else if (e.code == "weak-password") {
        Get.snackbar(
          'Weak Password',
          '${e.message}',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.cancel),
        );
      } else if (e.code == "email-already-in-use") {
        Get.snackbar(
          'Email Already In Use',
          '${e.message}',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.cancel),
        );
      } else if (e.code == "network-request-failed") {
        Get.snackbar(
          'network-request-failed',
          '${e.message}',
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.cancel),
        );
      }
    }
  }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  String get email => emailController.text.trim();
  String get password => passwordController.text.trim();
  String get name => nameController.text.trim();

  var loading = false;
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 70, 132, 255),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              transform: Matrix4.translationValues(0, -10, 0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
            ),
            Center(
              child: Container(
                height: heightScreen * 0.85,
                width: widthScreen * 0.85,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: heightScreen * 0.01,
                    ),
                    Image.asset(
                      'assets/Login.png',
                      width: widthScreen * 0.50,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: heightScreen * 0.01,
                      ),
                    ),
                    textField(
                      heightScreen: heightScreen,
                      widthScreen: widthScreen,
                      Controller: nameController,
                      mainText: 'Fullname',
                      hintText: 'Fullname',
                      NotShowingText: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textField(
                      heightScreen: heightScreen,
                      widthScreen: widthScreen,
                      Controller: emailController,
                      mainText: 'E-mail',
                      hintText: 'exmaple@gmail.com',
                      NotShowingText: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textField(
                      heightScreen: heightScreen,
                      widthScreen: widthScreen,
                      Controller: passwordController,
                      mainText: 'Password',
                      hintText: 'At least 6 characters',
                      NotShowingText: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          transform: Matrix4.translationValues(-10, 0, 0),
                          child: TextButton(
                              onPressed: () {
                                Get.to(forgotPasswordPage());
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(fontSize: 13),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: heightScreen * 0.03,
                      ),
                    ),
                    SizedBox(
                      width: widthScreen * 0.75,
                      height: heightScreen * 0.07,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          signUp(email, password, name);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: !loading,
                              child: Text(
                                'Sign Up',
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
                    Expanded(
                      child: SizedBox(
                        height: heightScreen * 0.1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        Container(
                          transform: Matrix4.translationValues(-8, 0, 0),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                Get.to(loginPage());
                              });
                            },
                            child: Text('Log In'),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(
                        height: heightScreen * 0.01,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class textField extends StatelessWidget {
  final double heightScreen;
  final double widthScreen;
  final TextEditingController Controller;
  final String mainText;
  final String hintText;
  final bool NotShowingText;

  const textField({
    super.key,
    required this.heightScreen,
    required this.widthScreen,
    required this.Controller,
    required this.mainText,
    required this.hintText,
    required this.NotShowingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                mainText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: heightScreen * 0.01,
          ),
          SizedBox(
            width: widthScreen * 0.75,
            height: heightScreen * 0.07,
            child: TextField(
              controller: Controller,
              obscureText: NotShowingText,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(83, 219, 218, 216),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 133, 132, 130),
                  fontSize: 13,
                  height: 1.75,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
