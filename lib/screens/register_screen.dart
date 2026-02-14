import 'package:doc_appoint_frontend/screens/login_screen.dart';
import 'package:doc_appoint_frontend/screens/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration Successful")));
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context)=> PatientHomeScreen(token: "token"),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create account", style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            Container( // could use CircleAvatar better
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Add Logo",
                style: TextStyle(fontSize: 18),
              ),
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
                      border: OutlineInputBorder(),
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
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                      hintText: "1234567890",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      }
                      if (value.length != 10) {
                        return "Invalid phone number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                    onPressed: _submitForm,
                    child: Text("Register"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.black),            
              children: [
                TextSpan(
                  text: 'Login now', 
                  style: TextStyle(color: Colors.blueAccent),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Login Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                ),

              ]
            ))
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(26, 213, 196, 196),
    );
  }
}




// const Color.fromARGB(255, 6, 24, 39)