import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quiz/app/data/remote/fetch/model/GetResModel.dart';
import 'package:quiz/app/data/remote/fetch/model/PostResponseModel.dart';
import 'package:quiz/app/data/remote/fetch/remote_source.dart';
import 'package:quiz/app/core/base/base_remote_source.dart';

class RemoteSourceImpl extends BaseRemoteSource implements RemoteSource {
  @override
  Future createApiService(param) async {
    log('create param-- $param');
    log('CreateApiService -- ${param.toJson()}');
    try {
      var formData = await param.toFormData();
      var endpoint = 'RemoteEndPaths._API';
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
    var endpoint = 'RemoteEndPaths.ListDropAPI';
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
}
