import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liste_des_taches/liste.dart';

final Color bleu = Color.fromARGB(255, 10, 41, 242);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visible = false;
  bool isSigning = false;
  bool remember = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setIsSigning(bool val) {
    setState(() {
      isSigning = val;
    });
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(email + ' est connecté')));
      print(userCredential.user!.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Echec connexion')));
      return false;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Container(
                child: Column(
                  children: [
                    LabelWidget(content: 'E-mail'),
                    TextFieldWidget(
                        hintText: 'Enter your email',
                        obscure: false,
                        controller: emailController),
                    LabelWidget(content: 'Password'),
                    TextFieldWidget(
                        hintText: 'Enter your password',
                        obscure: true,
                        controller: passwordController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: remember,
                              onChanged: (v) {
                                setState(() {
                                  remember = v!;
                                });
                              },
                              focusColor: bleu,
                              checkColor: bleu,
                              activeColor: Colors.white,
                            ),
                            Text(
                              'Remember me',
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: bleu),
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: bleu,
                              foregroundColor: Colors.white,
                              elevation: 1,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              setIsSigning(true);
                              final bool res = await login(
                                  context,
                                  emailController.text,
                                  passwordController.text);
                              setIsSigning(false);
                              if (res)
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ListePage()));
                            },
                            child: isSigning
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget TextFieldWidget(
      {obscure, hintText, TextEditingController? controller}) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 235, 233, 233),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure && !visible,
        decoration: InputDecoration(
          suffixIcon: obscure
              ? IconButton(
                  color: bleu,
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}

class LabelWidget extends StatelessWidget {
  final String content;
  const LabelWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          content,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
