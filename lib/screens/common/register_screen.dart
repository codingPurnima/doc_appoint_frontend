import 'package:doc_appoint_frontend/screens/common/login_screen.dart';
import 'package:doc_appoint_frontend/services/auth_service.dart';
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();

      final success = await authService.register(
        _nameController.text.trim(),
        _mobileController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful. Please Login"),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User exists already")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Create account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 6, 24, 39),
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 30),
              CircleAvatar(
                radius: 75,
                backgroundColor: Colors.grey[300],
                backgroundImage: AssetImage(
                  'assets/images/DocAppointLogo.jpeg',
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
                        if (value.contains("[^a-zA-z]")) {
                          return "Name must contain only letters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
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
                        "Register",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  children: [
                    TextSpan(
                      text: 'Login now',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 20),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFDCE6F1),
    );
  }
}
