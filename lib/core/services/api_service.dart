import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/category_model.dart';
import '../../data/models/question_model.dart';

class ApiService {
  static const String _baseUrl = 'https://sadiks-quiz-apihub.lovable.app/api/v1';

  // Fetch all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        
        if (decodedData['success'] == true) {
          final List<dynamic> data = decodedData['data'];
          return data.map((json) => CategoryModel.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch questions for a specific category
  Future<List<QuestionModel>> getQuestions(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories/$categoryId/questions'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = json.decode(response.body);
        
        if (decodedData['success'] == true) {
          final List<dynamic> data = decodedData['data'];
          return data.map((json) => QuestionModel.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load questions');
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}