import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/auth_service_dart.dart';
import 'package:firebase_auth_app/home_screen.dart';
import 'package:firebase_auth_app/login_file.dart';
import 'package:firebase_auth_app/register_form.dart';
import 'package:firebase_auth_app/reset_password_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<User?>(
              stream: authService.getAuthUser(),
              builder: (context, snapshot) {
                return MaterialApp(
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                    ),
                    home: snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : snapshot.hasData
                            ? HomeScreen(snapshot.data as User)
                            : MainScreen(),
                    routes: {
                      HomeScreen.routeName: (_) {
                        return HomeScreen(snapshot.data as User);
                      },
                      ResetPasswordScreen.routeName: (_) {
                        return ResetPasswordScreen();
                      }
                    });
              }),
    );
  }
}

class MainScreen extends StatefulWidget {
  static String routeName = '/';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool loginScreen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('firebase Auth'),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              loginScreen ? LoginForm() : RegisterForm(),
              SizedBox(height: 5),
              loginScreen
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          loginScreen = false;
                        });
                      },
                      child: Text('No account? Sign up here!'))
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          loginScreen = true;
                        });
                      },
                      child: Text('Exisiting user? Login in here!')),
              loginScreen
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ResetPasswordScreen.routeName);
                      },
                      child: Text('Forgotten Password'))
                  : Center()
            ],
          )),
    );
  }
}
