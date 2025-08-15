import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:quiz/app/data/local/question_local/questions_local_source.dart';
import 'package:quiz/app/data/remote/fetch/model/GetResModel.dart';
import 'package:quiz/app/data/remote/fetch/model/PostResponseModel.dart';
import 'package:quiz/app/data/remote/fetch/remote_source.dart';
import 'package:quiz/app/module/home/model/model.dart';
import 'package:quiz/app/utils/core/base/base_remote_source.dart';
import 'package:quiz/app/utils/core/services/service_locator.dart';

class QustionsLocalSourceImpl extends BaseRemoteSource
    implements QuestionLocalSource {
  @override
  Future createApiService(param) async {
    log('create param-- $param');
    log('CreateApiService -- ${param.toJson()}');
    try {
      var formData = await param.toFormData();
      var endpoint = 'RemoteEndPaths.FISH_COMPLAIN_API';
      var dioCall = dioClient.post(endpoint, data: formData);

      return callApiWithErrorParser(
        dioCall,
      ).then((response) => _parseComplainCreateResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  dynamic _parseComplainCreateResponse(Response<dynamic> response) {
    return PostResponseModel.fromJson(response.data);
  }

  @override
  Future fetchGet(complainId) async {
    var userId = await '_userRepository.getUserId()';
    // var endpoint = "project/dealer/cat/marketing/officer/wise/dd/list/$CategoryId/$userId";
    var endpoint = 'RemoteEndPaths.dealerListDropAPI';
    var dioCall = dioClient.get(endpoint);

    try {
      return callApiWithErrorParser(
        dioCall,
      ).then((response) => _parseDelarResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  GetResponseModel _parseDelarResponse(Response<dynamic> response) {
    return response.data;
  }

  @override
  Future fetchQuestionsGet(param) async {
    final data = await rootBundle.loadString('assets/questions.json');
    final jsonData = json.decode(data) as List;
    var _questions = jsonData.map((q) => Question.fromJson(q)).toList();

    // TODO: implement fetchQuestionsGet

    return _questions;
  }
}
