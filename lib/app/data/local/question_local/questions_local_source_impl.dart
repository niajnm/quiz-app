import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quiz/app/data/local/question_local/questions_local_source.dart';
import 'package:quiz/app/domain/model/question_model.dart';
import 'package:quiz/app/core/base/base_remote_source.dart';

class QustionsLocalSourceImpl extends BaseRemoteSource
    implements QuestionLocalSource {
  @override
  Future fetchQuestionsGet(param) async {
    final data = await rootBundle.loadString('assets/questions.json');
    final jsonData = json.decode(data) as List;
    var questions = jsonData.map((q) => Question.fromJson(q)).toList();
    return questions;
  }
}
