import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/category_model.dart';
import '../quiz/quiz_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    _categoriesFuture = _apiService.getCategories();
  }

  IconData _getCategoryIcon(String title) {
    final lower = title.toLowerCase();

    if (lower.contains('math')) return Icons.calculate_rounded;
    if (lower.contains('physics')) return Icons.bolt_rounded;
    if (lower.contains('chemistry')) return Icons.science_rounded;
    if (lower.contains('biology')) return Icons.biotech_rounded;
    if (lower.contains('computer')) return Icons.computer_rounded;
    if (lower.contains('science')) return Icons.science_rounded;
    if (lower.contains('geography')) return Icons.public_rounded;
    if (lower.contains('history')) return Icons.account_balance_rounded;
    if (lower.contains('general')) return Icons.quiz_rounded;
    if (lower.contains('english')) return Icons.menu_book_rounded;
    if (lower.contains('technology')) return Icons.memory_rounded;

    return Icons.school_rounded;
  }

  Color _getCategoryColor(String title) {
    final lower = title.toLowerCase();

    if (lower.contains('math')) return const Color(0xFFEF4444);
    if (lower.contains('physics')) return const Color(0xFFF59E0B);
    if (lower.contains('chemistry')) return const Color(0xFF10B981);
    if (lower.contains('biology')) return const Color(0xFFEC4899);
    if (lower.contains('computer')) return const Color(0xFF3B82F6);
    if (lower.contains('science')) return const Color(0xFF14B8A6);
    if (lower.contains('history')) return const Color(0xFF8B5CF6);
    if (lower.contains('geography')) return const Color(0xFF06B6D4);
    if (lower.contains('general')) return const Color(0xFF6366F1);

    return const Color(0xFF6366F1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF111827),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6366F1),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      color: Color(0xFF4F46E5),
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Unable to load quiz categories. Please check your internet connection and tap Retry.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 240,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              _loadCategories();
                            });
                          },
                          child: Ink(
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "Retry",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No categories found.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.78,
                ),
              itemBuilder: (context, index) {
                final category = categories[index];

                final color = _getCategoryColor(category.name);
                final icon = _getCategoryIcon(category.name);

                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          categoryId: category.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withOpacity(.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 28,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          category.description?.isNotEmpty == true
                              ? category.description!
                              : "Test your knowledge",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Divider(
                          color: Color(0xFFF3F4F6),
                          height: 1,
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Start",
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}