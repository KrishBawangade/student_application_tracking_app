import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_application_tracking_app/providers/user_auth_provider.dart';
import 'package:student_application_tracking_app/services/firebase/firebase_messaging_class.dart';
import 'package:student_application_tracking_app/utils/constants.dart';
import 'package:student_application_tracking_app/utils/functions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseMessagingClass _messaging = FirebaseMessagingClass();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginButtonEnabled = false;
  bool _isLoading = false;
  bool _obscureText = true; // For password visibility toggle

  @override
  void initState() {
    super.initState();
    _messagingRequests();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _messagingRequests() async {
    await _requestPermission();
    _handleForegroundMessage();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission();
  }

  void _handleForegroundMessage() {
    _messaging.handleForegroundMessage(onMessage: (RemoteMessage message) {
      debugPrint("Foreground message received: ${message.notification?.body}");
    });
  }

  void _validateInputs() {
    setState(() {
      _isLoginButtonEnabled = _formKey.currentState!.validate();
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserAuthProvider userAuthProvider = Provider.of(context, listen: false);
        await userAuthProvider.signInUserUsingEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
          onSuccess: () {
            setState(() {
              _isLoading = false;
            });
            // Navigate to the next screen
          },
          onError: (error) {
            setState(() {
              _isLoading = false;
            });
            AppFunctions.showDismissibleSnackBar(context, error); // Use AppFunctions
          },
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        AppFunctions.showDismissibleSnackBar(context, "An error occurred: $e"); // Use AppFunctions
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              onChanged: _validateInputs,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppConstants.loginPageImagePath, height: 300),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email), // Email icon
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock), // Password icon
                        suffixIcon: IconButton( // Password visibility toggle
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoginButtonEnabled ? _handleLogin : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    textStyle: const TextStyle(fontSize: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text('Login'),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}