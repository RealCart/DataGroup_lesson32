import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StreamListener extends StatefulWidget {
  const StreamListener({
    super.key,
    required this.onListen,
    required this.child,
  });

  final ValueChanged<User?> onListen;
  final Widget child;

  @override
  State<StreamListener> createState() => _StreamListenerState();
}

class _StreamListenerState extends State<StreamListener> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen(
      (user) => widget.onListen.call(user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
