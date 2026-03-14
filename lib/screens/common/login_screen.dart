import 'package:doc_appoint_frontend/screens/doctor/doctor_home_screen.dart';
import 'package:doc_appoint_frontend/screens/patient/patient_main_screen.dart';
import 'package:doc_appoint_frontend/screens/common/register_screen.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // bool isLoading = false; ADD LATER

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // context works here because it is inside a State class (StatefulWidget). Inside a State<T> class, Flutter automatically provides a context getter.
  void _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();

      final result = await authService.login(
        _nameController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result != null) {
        final accessToken = result["access_token"];
        final role = result["role"];

        if(accessToken != null){
            if(role=="patient"){
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PatientMainScreen()),
              (route) =>
                  false, // prevents going back to register again after success because it is still there in the stack as we followed this route: register-push-> login.
              );
            }else if(role=="doctor"){
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
              (route) =>
                  false, // prevents going back to register again after success because it is still there in the stack as we followed this route: register-push-> login.
              );
          }
        }       
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              child: Text("Logo"),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      hintText: "First Middle Last",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      if (value.length < 3) {
                        return "Name must be at least 3 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "asCjiV34%#",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 6, 24, 39),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      fixedSize: Size(125, 15),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Not registered? ",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigate to Login Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFDCE6F1),
    );
  }
}




// const Color.fromARGB(255, 6, 24, 39)