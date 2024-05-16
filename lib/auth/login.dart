import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../components/CustomButtonAuth‎.dart';
import '../components/CustomLogoAuth.dart';
import '../components/CustomTextForm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 50),
              const CustomLogoAuth(),
              Container(height: 20),
              const Text("Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Container(height: 10),
              const Text("Login To Continue Using The App",
                  style: TextStyle(color: Colors.grey)),
              Container(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "ُEnter Your Email", mycontroller: email),
              Container(height: 10),
              const Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "ُEnter Your Password", mycontroller: password),

            ],
          ),
          CustomButtonAuth(title: "login", onPressed: () async {try {
            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email.text,
                password: password.text
            );
            final User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final CollectionReference users = FirebaseFirestore.instance.collection('users');
              final DocumentSnapshot userDoc = await users.where('email', isEqualTo: user.email).get().then((querySnapshot) {
                return querySnapshot.docs.first;
              });

              final Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
              final String? username = userData['username'];
              if (username != null) {
                user.updateDisplayName(username);
              }
            }
            Navigator.of(context).pushReplacementNamed("home");
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('wrong credentials'),
              ),
            );
          }}),
          Container(height: 20),


          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("signup") ;
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Don't Have An Account ? ",
                ),
                TextSpan(
                    text: "Register",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}