import 'package:flutter/material.dart';
import 'package:hometechfix/pages/signup_page.dart';

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

enum AppRole { user, technician }

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  static const Color mainBlue = Color(0xFF1E88E5);
  AppRole? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: mainBlue),
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
    );

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Centered logo + welcome
              Column(
                children: [
                  Image.asset('assets/logo.png', height: 90),
                  const SizedBox(height: 12),
                  const Text(
                    "Welcome to HomeTechFix",
                    style: TextStyle(
                      color: mainBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Choose your role",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "This helps us personalize your experience.",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),

              const SizedBox(height: 30),

              // User / Homeowner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _RoleCard(
                  title: "User / Homeowner",
                  subtitle: "Book and track your home repair services.",
                  icon: Icons.home_outlined,
                  selected: _selected == AppRole.user,
                  onTap: () => setState(() => _selected = AppRole.user),
                  color: mainBlue,
                ),
              ),
              const SizedBox(height: 18),

              // Technician
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _RoleCard(
                  title: "Technician",
                  subtitle: "Provide services and manage your schedule.",
                  icon: Icons.handyman_outlined,
                  selected: _selected == AppRole.technician,
                  onTap: () => setState(() => _selected = AppRole.technician),
                  color: mainBlue,
                ),
              ),

              const Spacer(),

              // Continue Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _selected == null
                        ? null
                        : () {
                            // Navigate to SignUpPage with appropriate role
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SignUpPage(
                                  isTechnician: _selected == AppRole.technician,
                                ),
                              ),
                            );
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: mainBlue,
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.grey.shade500,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Continue"),
                  ),
                ),
              ),

              // Already have account link
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        // If role is selected, pass it to login page
                        if (_selected != null) {
                          Navigator.pushNamed(
                            context,
                            '/login',
                            arguments: {'isTechnician': _selected == AppRole.technician},
                          );
                        } else {
                          // If no role selected, just go to login (will default to user)
                          Navigator.pushNamed(context, '/login');
                        }
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          color: mainBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 2.2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: selected ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}