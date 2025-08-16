import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'exceptions/api_exception.dart';
import 'exceptions/app_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/not_found_exception.dart';
import 'exceptions/service_unavailable_exception.dart';

Exception handleError(String error) {
  //final logger = BuildConfig.instance.config.logger;
  // logger.e("Generic exception: $error");

  return AppException(message: error);
}

Exception handleDioError(DioError dioError) {
  switch (dioError.type) {
    case DioExceptionType.cancel:
      return AppException(message: "Request to API server was cancelled 🙂");
    case DioExceptionType.connectionTimeout:
      return AppException(message: "Connection timeout with API server 🙂");
    case DioExceptionType.unknown:
      return NetworkException("There is no internet connection 🙂");
    case DioExceptionType.receiveTimeout:
      return TimeoutException(
          "Receive timeout in connection with API server 🙂");
    case DioExceptionType.sendTimeout:
      return TimeoutException("Send timeout in connection with API server 🙂");
    case DioExceptionType.badResponse:
      return _parseDioErrorResponse(dioError);
    case DioExceptionType.badCertificate:
      return AppException(message: "Invalid certificate");
    case DioExceptionType.connectionError:
      return NetworkException("There is no internet connection");
  }

}

Exception _parseDioErrorResponse(DioError dioError) {
  //final logger = BuildConfig.instance.config.logger;

  int statusCode = dioError.response?.statusCode ?? -1;
  String? status;
  String? serverMessage;

  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode = dioError.response?.data["statusCode"];
    }
    status = dioError.response?.data["status"];
    serverMessage = dioError.response?.data["message"];
  } catch (e) {
    //logger.i("$e");
    // logger.i(s.toString());

    serverMessage = "Something went wrong. Please try again later.";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException("Service Temporarily Unavailable");
    case HttpStatus.notFound:
      return NotFoundException(serverMessage ?? "", status ?? "");
    default:
      return ApiException(
          httpCode: statusCode,
          status: status ?? "",
          message: serverMessage ?? "");
  }
}
