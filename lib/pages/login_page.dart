import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hometechfix/auth_wrapper.dart';

class LoginPage extends StatefulWidget {
  final bool isTechnician;
  const LoginPage({super.key, this.isTechnician = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5));
    final theme = Theme.of(context).copyWith(
      colorScheme: colorScheme,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Gradient header background
            Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    // Logo + App name
                    Column(
                      children: [
                        Container(
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(.35)),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/logo.png",
                            height: 56,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "HomeTechFix",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fast & trusted home repair bookings",
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Floating card with form
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 18,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Welcome back",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Log in to manage your bookings and repairs.",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 20),

                            // Email field
                            TextFormField(
                              controller: _usernameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                hintText: "Enter your email",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return "Please enter your email";
                                }
                                if (!val.contains('@')) return "Enter a valid email";
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip:
                                      _obscurePassword ? "Show password" : "Hide password",
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter your password";
                                }
                                if (val.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 18),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState?.validate() != true) return;
                                        setState(() => _isLoading = true);

                                        try {
                                          // Sign in with Firebase Auth
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: _usernameController.text.trim(),
                                            password: _passwordController.text.trim(),
                                          );

                                          // Navigate to AuthWrapper and clear all routes
                                          if (!mounted) return;
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (_) => const AuthWrapper(),
                                            ),
                                            (route) => false,
                                          );
                                          
                                        } on FirebaseAuthException catch (e) {
                                          if (!mounted) return;
                                          
                                          String message = "Login failed";
                                          if (e.code == 'user-not-found') {
                                            message = "No user found for that email.";
                                          } else if (e.code == 'wrong-password') {
                                            message = "Wrong password.";
                                          } else if (e.code == 'invalid-email') {
                                            message = "Invalid email format.";
                                          } else if (e.code == 'invalid-credential') {
                                            message = "Invalid email or password.";
                                          }

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(message)),
                                          );
                                        } catch (e) {
                                          if (!mounted) return;
                                          
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: $e')),
                                          );
                                        } finally {
                                          if (mounted) {
                                            setState(() => _isLoading = false);
                                          }
                                        }
                                      },
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Log In"),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Sign up link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "I don't have an account, ",
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/signup'),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Small footnote
                    Text(
                      "By continuing, you agree to our Terms & Privacy Policy.",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}