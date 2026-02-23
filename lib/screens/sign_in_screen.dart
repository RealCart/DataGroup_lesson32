import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_sample/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
      appBar: AppBar(title: Text("Sign In"), centerTitle: true),
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
                      log("validated");
                      try {
                        final userCredentail = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
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
                        log("Success");
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        log("$e, type: ${e.runtimeType}", name: "Error");
                      }
                    }
                  },
                  child: Text("Sign in"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
