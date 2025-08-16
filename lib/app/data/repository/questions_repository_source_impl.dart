import 'package:quiz/app/data/local/question_local/questions_local_source.dart';
import 'package:quiz/app/data/repository/questions_repository_source.dart';
import 'package:quiz/app/core/services/service_locator.dart';

class QuestionRepositorySourceImpl implements QuestionRepositorySource {
  final QuestionLocalSource _remoteSource =
      serviceLocator<QuestionLocalSource>();

  @override
  Future fetchQuestionsGet(param) {
    return _remoteSource.fetchQuestionsGet(param);
  }
}
