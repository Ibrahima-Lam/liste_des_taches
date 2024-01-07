import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:liste_des_taches/liste.dart';
import 'package:liste_des_taches/service/storage_sevice.dart';

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
  StorageService _storageService = StorageService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void setIsSigning(bool val) {
    setState(() {
      isSigning = val;
    });
  }

  Future<bool> _checkUser() async {
    final Map<String, String?> data = await _storageService.getData();
    // ignore: use_build_context_synchronously
    print(data);
    setIsSigning(true);
    final bool res =
        await login(context, data['email'] ?? '', data['password'] ?? '');
    setIsSigning(false);

    return res;
  }

  @override
  void initState() {
    super.initState();
    _checkUser().then((value) {
      if (value) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ListePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Pas d'utilisateur ensegitré ")));
      }
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

      return false;
    }
  }

  @override
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
                child: const Row(
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
              const SizedBox(
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
                        isSigning
                            ? Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bleu,
                                    foregroundColor: Colors.white,
                                    elevation: 1,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: bleu,
                                    foregroundColor: Colors.white,
                                    elevation: 1,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    _sign();
                                  },
                                  child: Text(
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
                  icon: const Icon(Icons.remove_red_eye),
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

  void _sign() async {
    setIsSigning(true);
    final bool res =
        await login(context, emailController.text, passwordController.text);
    setIsSigning(false);
    if (res) {
      if (remember) {
        await _storageService.setData(
            email: emailController.text, password: passwordController.text);
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ListePage()));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Echec de connexion')));
    }
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
