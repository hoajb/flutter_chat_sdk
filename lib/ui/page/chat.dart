import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userName;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    _userName = "";
    final FirebaseUser user = await _auth.currentUser();

    setState(() {
      _userName = user.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("UserName: " + _userName),
      ),
      color: Colors.brown,
    );
  }
}
