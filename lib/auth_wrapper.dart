import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hometechfix/pages/choose_role.dart';
import 'package:hometechfix/pages/main_navigation/main_navigation.dart';
import 'package:hometechfix/pages/technician/technician_home_page.dart';

/// Wrapper that handles authentication state and routes users accordingly
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E88E5),
              ),
            ),
          );
        }

        // If user is not logged in, show role selection
        if (!snapshot.hasData || snapshot.data == null) {
          return const RoleSelectScreen();
        }

        // User is logged in, check their role from Firestore
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data!.uid)
              .get(),
          builder: (context, userSnapshot) {
            // Show loading while fetching user data
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1E88E5),
                  ),
                ),
              );
            }

            // If user document doesn't exist or has error, logout and show role selection
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              // Sign out user if their data doesn't exist
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FirebaseAuth.instance.signOut();
              });
              return const RoleSelectScreen();
            }

            // Get user role from Firestore
            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
            final isTechnician = userData?['isTechnician'] ?? false;

            // Route to appropriate home page based on role
            if (isTechnician) {
              // Check if technician has completed profile setup
              final hasCompletedProfile = userData?['profileCompleted'] ?? false;
              
              if (!hasCompletedProfile) {
                // If profile not completed, show profile completion page
                // For now, we'll go directly to technician home
                // You can add profile completion check here later
                return const TechnicianHomePage();
              }
              return const TechnicianHomePage();
            } else {
              return const MainNavigationPage();
            }
          },
        );
      },
    );
  }
}