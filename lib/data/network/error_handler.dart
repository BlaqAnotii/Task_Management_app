// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../utils/snack_message.dart';

// This handles the errors in the app i made use of DioError
void handleError(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.cancel:
        // showCustomToast("Request to API server was cancelled");
        print("Request to API server was cancelled");
        break;
      case DioExceptionType.connectionTimeout:
        showCustomToast("Connection timeout with API server");
        print("Connection timeout with API server");
        break;
      case DioExceptionType.connectionError:
        showCustomToast("Please Enable Internet Connect To Use Arbiter ");
        break;
      case DioExceptionType.receiveTimeout:
        // showCustomToast("Receive timeout in connection with API server");
        print("Receive timeout in connection with API server");
        break;
      case DioExceptionType.badResponse:
        final errorData = error.response?.data;
        if (errorData != null) {
          if (errorData is Map<String, dynamic>) {
            final errorMessage = errorData["message"];
            if (errorMessage != null) {
              showCustomToast(errorMessage);
              print(errorMessage);
            } else if (errorData["errors"] != null) {
              final errors = errorData["errors"] as Map<String, dynamic>;
              errors.forEach((key, value) {
                if (value is List) {
                  for (var msg in value) {
                    showCustomToast(msg);
                    print(msg);
                  }
                } else {
                  showCustomToast(value.toString());
                  print(value.toString());
                }
              });
            } else {
              showCustomToast("An unexpected error occurred");
              print("An unexpected error occurred");
            }
          } else {
            showCustomToast("An unexpected error occurred");
            print("An unexpected error occurred");
          }
        } else {
          showCustomToast("An unexpected error occurred");
          print("An unexpected error occurred");
        }
        break;
      case DioExceptionType.sendTimeout:
        // showCustomToast("Send timeout in connection with API server");
        print("Send timeout in connection with API server");
        break;
      default:
        showCustomToast("Something went wrong");
        print("Something went wrong");
        break;
    }
  } else {
    var errorString = error.toString();
    try {
      var json = jsonDecode(errorString);
      var nameJson = json['message'];
      showCustomToast(nameJson);
      print(nameJson);
      throw nameJson;
    } catch (e) {
      showCustomToast("An unexpected error occurred");
      print("An unexpected error occurred: $e");
    }
  }
}
