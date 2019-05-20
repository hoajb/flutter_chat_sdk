import 'package:flutter/material.dart';

import '../tab_navigator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: MaterialButton(
            child: Text("Login by Google"),
            onPressed: () {
              Navigator.pushNamed(
                context, TabNavigatorRoutes.main,
//                  arguments: MovieCategoryPageArguments(
//                      movies: movieList.childrenMovies, title: movieList.title)
              );
            },
          ),
        ),
      ),
    );
  }
}
