import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../category/category_screen.dart';
// Note: ProfileScreen and AuthService imports removed as we moved Logout to Profile.

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!
        : 'Guest';

    return Scaffold(
      // 1. The Global Design System: Light Grey Background
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Professional Typography Hierarchy
              const Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ready for today's quiz?",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              
              const SizedBox(height: 40),

              // 3. The Hero Card (The single gradient allowed in the app)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20), // Standardized 20px radius
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Today\'s Challenge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sharpen your skills\nacross all categories!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Main Action Button inside the card
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CategoryScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4F46E5),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.18),
                          surfaceTintColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Left icon container
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.explore_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 14),

                            // Label
                            const Expanded(
                              child: Text(
                                "Browse Categories",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1B4B),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),

                            // Right arrow in a tinted pill
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4F46E5).withOpacity(0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Color(0xFF4F46E5),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),

              // 4. Honest & Helpful "How to Play" Section
              const Text(
                'How to Play',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.library_books_rounded, color: Color(0xFF4F46E5), size: 28),
                      title: Text('1. Choose a Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      subtitle: Text('Browse the library and select a topic.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    ),
                    Divider(height: 16, color: Color(0xFFF3F4F6)),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.psychology_rounded, color: Color(0xFF4F46E5), size: 28),
                      title: Text('2. Answer Questions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      subtitle: Text('Pick the correct options to test your skills.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                    ),
                    Divider(height: 16, color: Color(0xFFF3F4F6)),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.emoji_events_rounded, color: Color(0xFF4F46E5), size: 28),
                      title: Text('3. Get Results', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      subtitle: Text('See your final score instantly at the end.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
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