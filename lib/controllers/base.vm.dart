import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagementapp/services/navigation_service.dart';

import '../services/app_cache.dart';
import '../services/locator.dart';

enum ViewState { Idle, Loading, Success, Error }

class BaseViewModel extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;
  String? errorMessage;
  NavigationService navigationService = getIt<NavigationService>();
  

  AppData cache = getIt<AppData>();

  ViewState get viewState => _viewState;

  int cartItemsCount = 0;
  String? source;
  File? imageFile;

  set viewState(ViewState newState) {
    _viewState = newState;
    notifyListeners();
  }

  void setError(String? error) {
    errorMessage = error;
    notifyListeners();
  }

  bool isLoading = false;

  void startLoader() {
    if (!isLoading) {
      isLoading = true;
      viewState = ViewState.Loading;
      notifyListeners();
    }
  }

  void stopLoader() {
    if (isLoading) {
      isLoading = false;
      viewState = ViewState.Loading;
      notifyListeners();
    }
  }
}
