class PostResponseModel {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String category; // optional
  final bool isMath; // optional, for LaTeX rendering

  PostResponseModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.category = '',
    this.isMath = false,
  });

  // Factory constructor to parse JSON
  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    return PostResponseModel(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      category: json['category'] ?? '',
      isMath: json['is_math'] ?? false,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'category': category,
      'is_math': isMath,
    };
  }
}
