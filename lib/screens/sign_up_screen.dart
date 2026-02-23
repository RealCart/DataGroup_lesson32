import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_sample/screens/home_screen.dart';
import 'package:firebase_auth_sample/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const .symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text("Email"),
                TextFormField(controller: _emailController),
                Text("password"),
                TextFormField(controller: _passwordController),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final userCredentail = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredentail.user!.uid)
                            .set(
                              {
                                'userId': userCredentail.user!.uid,
                                'email': userCredentail.user!.email,
                                'photoUrl': userCredentail.user!.photoURL,
                              },
                            );

                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        log("$e, type: ${e.runtimeType}", name: "Error");
                      }
                    }
                  },
                  child: Text("Sign up"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text("Sign in"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
