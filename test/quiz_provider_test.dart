import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/app/data/local/preference/score_local_source.dart';
import 'package:quiz/app/data/repository/questions_repository_source.dart';
import 'package:quiz/app/domain/model/question_model.dart';
import 'package:quiz/app/presentation/view_model/quiz_provider.dart';
import 'package:quiz/app/core/services/service_locator.dart';

// Manual mock implementations
class MockQuestionRepositorySource implements QuestionRepositorySource {
  List<Question>? _mockQuestions;

  void setMockQuestions(List<Question> questions) {
    _mockQuestions = questions;
  }

  @override
  Future<List<Question>> fetchQuestionsGet(param) async {
    return _mockQuestions ?? [];
  }
}

class MockScoreLocalSource implements ScoreLocalSource {
  final List<Map<String, dynamic>> _leaderboard = [];

  @override
  Future<void> saveScore(String name, int score) async {
    _leaderboard.add({"name": name, "score": score});
    _leaderboard.sort((a, b) => b["score"].compareTo(a["score"]));
  }

  @override
  Future<List<Map<String, dynamic>>> loadLeaderboard() async {
    return List.from(_leaderboard);
  }
}

void main() {
  group('QuizProvider Score Calculation Tests', () {
    late QuizProvider quizProvider;
    late MockQuestionRepositorySource mockQuestionRepository;
    late MockScoreLocalSource mockScoreLocalSource;

    // Sample test questions
    final List<Question> testQuestions = [
      Question(
        question: "What is 2 + 2?",
        options: ["3", "4", "5", "6"],
        answerIndex: 1, // Index 1 = "4" is correct
      ),
      Question(
        question: "What is the capital of France?",
        options: ["London", "Berlin", "Paris", "Madrid"],
        answerIndex: 2, // Index 2 = "Paris" is correct
      ),
      Question(
        question: "What is 10 / 2?",
        options: ["4", "5", "6", "7"],
        answerIndex: 1, // Index 1 = "5" is correct
      ),
    ];

    setUpAll(() {
      // Reset service locator once before all tests
      serviceLocator.reset();
    });

    setUp(() {
      // Initialize mocks
      mockQuestionRepository = MockQuestionRepositorySource();
      mockScoreLocalSource = MockScoreLocalSource();

      // Ensure clean state
      try {
        if (serviceLocator.isRegistered<QuestionRepositorySource>()) {
          serviceLocator.unregister<QuestionRepositorySource>();
        }
      } catch (e) {
        // Ignore if not registered
      }

      try {
        if (serviceLocator.isRegistered<ScoreLocalSource>()) {
          serviceLocator.unregister<ScoreLocalSource>();
        }
      } catch (e) {
        // Ignore if not registered
      }

      // Register fresh mocks
      serviceLocator.registerLazySingleton<QuestionRepositorySource>(
        () => mockQuestionRepository,
      );
      serviceLocator.registerLazySingleton<ScoreLocalSource>(
        () => mockScoreLocalSource,
      );

      // Set up mock data
      mockQuestionRepository.setMockQuestions(testQuestions);

      // Create QuizProvider after service locator is set up
      quizProvider = QuizProvider();
    });

    tearDown(() {
      // Clean up after each test
      try {
        if (serviceLocator.isRegistered<QuestionRepositorySource>()) {
          serviceLocator.unregister<QuestionRepositorySource>();
        }
        if (serviceLocator.isRegistered<ScoreLocalSource>()) {
          serviceLocator.unregister<ScoreLocalSource>();
        }
      } catch (e) {
        // Ignore errors during cleanup
      }
    });

    test('Initial score should be 0', () {
      expect(quizProvider.score, equals(0));
      expect(quizProvider.answered, isFalse);
      expect(quizProvider.selectedAnswer, isNull);
      expect(quizProvider.currentIndex, equals(0));
    });

    test('Score should increment when correct answer is selected', () async {
      // Load questions
      await quizProvider.loadQuestions();
      expect(quizProvider.questions.length, equals(3));

      // Select correct answer for first question (index 1 = "4")
      quizProvider.selectAnswer(1);

      expect(quizProvider.score, equals(1));
      expect(quizProvider.answered, isTrue);
      expect(quizProvider.selectedAnswer, equals(1));
    });

    test('Score should not increment when wrong answer is selected', () async {
      // Load questions
      await quizProvider.loadQuestions();

      // Select wrong answer for first question (index 0 = "3")
      quizProvider.selectAnswer(0);

      expect(quizProvider.score, equals(0));
      expect(quizProvider.answered, isTrue);
      expect(quizProvider.selectedAnswer, equals(0));
    });

    test('Score should not increment when timer expires (index -1)', () async {
      // Load questions
      await quizProvider.loadQuestions();

      // Simulate timer expiry
      quizProvider.selectAnswer(-1);

      expect(quizProvider.score, equals(0));
      expect(quizProvider.answered, isTrue);
      expect(quizProvider.selectedAnswer, equals(-1));
    });

    test('Score should not increment for out-of-bounds answer index', () async {
      // Load questions
      await quizProvider.loadQuestions();

      // Select answer index that exceeds options length
      quizProvider.selectAnswer(10);

      expect(quizProvider.score, equals(0));
      expect(quizProvider.answered, isTrue);
      expect(quizProvider.selectedAnswer, equals(10));
    });

    test('Cannot select answer twice for same question', () async {
      // Load questions
      await quizProvider.loadQuestions();

      // Select correct answer
      quizProvider.selectAnswer(1);
      expect(quizProvider.score, equals(1));
      expect(quizProvider.answered, isTrue);

      // Try to select different answer (should be ignored)
      quizProvider.selectAnswer(0);
      expect(quizProvider.score, equals(1)); // Score should remain same
      expect(
        quizProvider.selectedAnswer,
        equals(1),
      ); // Selected answer should remain same
      expect(quizProvider.answered, isTrue);
    });

    test('Reset quiz should reset score to 0', () async {
      // Load questions and answer some
      await quizProvider.loadQuestions();
      quizProvider.selectAnswer(1);
      expect(quizProvider.score, equals(1));

      // Reset quiz
      quizProvider.resetQuiz();

      expect(quizProvider.score, equals(0));
      expect(quizProvider.currentIndex, equals(0));
      expect(quizProvider.answered, isFalse);
      expect(quizProvider.selectedAnswer, isNull);
    });

    test('Score boundary conditions with single question', () async {
      // Test with single question
      final singleQuestion = [
        Question(
          question: "Test question?",
          options: ["A", "B"],
          answerIndex: 0,
        ),
      ];

      mockQuestionRepository.setMockQuestions(singleQuestion);
      await quizProvider.loadQuestions();

      // Answer correctly
      quizProvider.selectAnswer(0);
      expect(quizProvider.score, equals(1));
    });

    test('Score with edge case answer indices', () async {
      await quizProvider.loadQuestions();

      // Test with negative index (not -1)
      quizProvider.selectAnswer(-5);
      expect(quizProvider.score, equals(0));
      expect(quizProvider.answered, isTrue);

      // Reset for next test
      quizProvider.resetQuiz();
      expect(quizProvider.answered, isFalse);

      // Test with very large positive index
      quizProvider.selectAnswer(999);
      expect(quizProvider.score, equals(0));
      expect(quizProvider.answered, isTrue);
    });

    test(
      'Score calculation maintains consistency after state changes',
      () async {
        await quizProvider.loadQuestions();

        // Record initial state
        final initialScore = quizProvider.score;
        expect(initialScore, equals(0));

        // Answer correctly
        quizProvider.selectAnswer(1);
        expect(quizProvider.score, equals(1));

        // Verify answer state is consistent
        expect(quizProvider.answered, isTrue);
        expect(quizProvider.selectedAnswer, equals(1));

        // Score should remain stable on subsequent calls to selectAnswer
        quizProvider.selectAnswer(0);
        expect(quizProvider.score, equals(1)); // Should not change
      },
    );

    test('Empty questions list handling', () async {
      // Set empty questions
      mockQuestionRepository.setMockQuestions([]);
      await quizProvider.loadQuestions();

      expect(quizProvider.questions.isEmpty, isTrue);
      expect(quizProvider.score, equals(0));
    });

    test('Question loading preserves initial state', () async {
      expect(quizProvider.score, equals(0));
      expect(quizProvider.currentIndex, equals(0));
      expect(quizProvider.answered, isFalse);

      await quizProvider.loadQuestions();

      // State should remain the same after loading
      expect(quizProvider.score, equals(0));
      expect(quizProvider.currentIndex, equals(0));
      expect(quizProvider.answered, isFalse);
      expect(quizProvider.questions.length, equals(3));
    });

    test('Score calculation for different questions', () async {
      await quizProvider.loadQuestions();

      // Test each question individually by resetting between tests

      // Test question 1 (correct answer index 1)
      quizProvider.selectAnswer(1); // Correct
      expect(quizProvider.score, equals(1));

      // Reset and test question 1 with wrong answer
      quizProvider.resetQuiz();
      quizProvider.selectAnswer(0); // Wrong
      expect(quizProvider.score, equals(0));

      // Reset and test timer expiry
      quizProvider.resetQuiz();
      quizProvider.selectAnswer(-1); // Timer expired
      expect(quizProvider.score, equals(0));
    });

    test('Score accumulation simulation', () async {
      // Test score accumulation by creating multiple quiz providers
      // to simulate answering different questions

      await quizProvider.loadQuestions();

      // Simulate answering first question correctly
      quizProvider.selectAnswer(1); // Correct for question 1
      expect(quizProvider.score, equals(1));

      // Create new provider instance to simulate next question
      final quizProvider2 = QuizProvider();
      await quizProvider2.loadQuestions();

      // Set the score manually to simulate continuation
      // (In real app, this would be maintained across questions)
      // For testing, we verify the selectAnswer logic works correctly for each question

      // Simulate second question (index 2 is correct for question 2)
      mockQuestionRepository.setMockQuestions([
        testQuestions[1],
      ]); // Only second question
      await quizProvider2.loadQuestions();
      quizProvider2.selectAnswer(2); // Correct answer

      // Since this is a new provider instance, score starts at 0 and becomes 1
      expect(quizProvider2.score, equals(1));
    });

    test('Comprehensive score validation', () async {
      await quizProvider.loadQuestions();

      // Test all possible scenarios for the first question
      final question1 = testQuestions[0];
      expect(question1.answerIndex, equals(1)); // Correct answer is index 1

      // Test correct answer
      quizProvider.selectAnswer(1);
      expect(quizProvider.score, equals(1));

      // Reset and test all wrong answers
      for (int i = 0; i < question1.options.length; i++) {
        if (i != question1.answerIndex) {
          quizProvider.resetQuiz();
          await quizProvider.loadQuestions();
          quizProvider.selectAnswer(i);
          expect(
            quizProvider.score,
            equals(0),
            reason: 'Wrong answer at index $i should not increment score',
          );
        }
      }

      // Test edge cases
      quizProvider.resetQuiz();
      await quizProvider.loadQuestions();
      quizProvider.selectAnswer(-1); // Timer expiry
      expect(quizProvider.score, equals(0));

      quizProvider.resetQuiz();
      await quizProvider.loadQuestions();
      quizProvider.selectAnswer(999); // Out of bounds
      expect(quizProvider.score, equals(0));
    });

    test('Score consistency across answer attempts', () async {
      await quizProvider.loadQuestions();

      // Answer correctly
      quizProvider.selectAnswer(1);
      expect(quizProvider.score, equals(1));

      // Try to answer again (should be ignored)
      final scoreBeforeSecondAttempt = quizProvider.score;
      quizProvider.selectAnswer(0);
      expect(quizProvider.score, equals(scoreBeforeSecondAttempt));

      // Try multiple more attempts
      quizProvider.selectAnswer(2);
      quizProvider.selectAnswer(3);
      quizProvider.selectAnswer(-1);
      expect(quizProvider.score, equals(scoreBeforeSecondAttempt));
    });
  });
}
