import 'package:flutter/material.dart';
// Import your model, API service, and quiz screen path here:
// import '../../../data/models/category_model.dart'; 
// import '../../../data/services/api_service.dart';
// import '../quiz/quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  // Helper method to dynamically assign clean Flutter Icons based on API title strings
  IconData _getCategoryIcon(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('math')) return Icons.calculate_rounded;
    if (lowerTitle.contains('physics')) return Icons.bolt_rounded;
    if (lowerTitle.contains('chemistry')) return Icons.science_rounded;
    if (lowerTitle.contains('biology')) return Icons.biotech_rounded;
    if (lowerTitle.contains('computer')) return Icons.computer_rounded;
    return Icons.menu_book_rounded; // Fallback professional icon
  }

  // Helper method to dynamically assign a smooth color theme to each card type
  Color _getCategoryColor(String title) {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('math')) return const Color(0xFFEF4444); // Red
    if (lowerTitle.contains('physics')) return const Color(0xFFF59E0B); // Amber
    if (lowerTitle.contains('chemistry')) return const Color(0xFF10B981); // Emerald
    if (lowerTitle.contains('biology')) return const Color(0xFFEC4899); // Pink
    if (lowerTitle.contains('computer')) return const Color(0xFF3B82F6); // Blue
    return const Color(0xFF6366F1); // Standard QuizVerse Purple
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Global Design System: Consistent depth background
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        // Replace this section with your actual API FutureBuilder data check!
        // This structural template shows exactly how to format the inner GridView:
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: GridView.builder(
            itemCount: 6, // Hardcoded for preview; map this to your snapshot.data!.length
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85, // Enforces consistent card height proportions
            ),
            itemBuilder: (context, index) {
              // Mock data mapping sample. Replace with your loop category variables:
              final String categoryName = ['Math', 'General Knowledge', 'Physics', 'Biology', 'Chemistry', 'Computer'][index];
              final String categoryId = 'mock_id'; 
              
              final cardColor = _getCategoryColor(categoryName);
              final cardIcon = _getCategoryIcon(categoryName);

              return GestureDetector(
                onTap: () {
                  // Navigate to your QuizScreen using the correct categoryId
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Surface Rule: White cards on grey background
                    borderRadius: BorderRadius.circular(20), // Consistent 20px radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Visual Anchor: Icon with a soft background circle tint
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cardIcon,
                          color: cardColor,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      // 2. High-Impact Text Hierarchy
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Test your knowledge',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      const SizedBox(height: 8),
                      // 3. Action Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cardColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: cardColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}