import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/category_card.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/category_model.dart';
import '../quiz/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch categories when the screen initializes
    _categoriesFuture = _apiService.getCategories();
  }

  // Helper method to keep our UI looking good with emojis
  String _getEmojiForCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('science')) return '🧪';
    if (lowerName.contains('geography')) return '🌍';
    if (lowerName.contains('tech')) return '💻';
    if (lowerName.contains('math')) return '🔢';
    if (lowerName.contains('history')) return '🏛️';
    return '📚'; // Default emoji
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Header
              const Text(
                '👋 Good Evening,',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's challenge your brain today.",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 24),
              
              // Search Bar
              const SearchBarWidget(),
              const SizedBox(height: 32),
              
              // Categories Section Header
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              
              // Dynamic Grid of Categories using FutureBuilder
              Expanded(
                child: FutureBuilder<List<CategoryModel>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    // 1. Loading State
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF4F46E5),
                        ),
                      );
                    }
                    
                    // 2. Error State
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Oops! Failed to load categories.\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    // 3. Empty State
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No categories available right now.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      );
                    }

                    // 4. Success State
                    final categories = snapshot.data!;
                    
                    return GridView.builder(
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryCard(
                          title: category.name,
                          emoji: _getEmojiForCategory(category.name),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  categoryId: category.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}