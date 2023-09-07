import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurantcity2/data/model/restaurants.dart';

import '../data/api/api_service.dart';
import '../utils/result_state.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService apiService;

  HomeProvider({required this.apiService}) {
    _fetchAllRestaurant();
  }

  ResultState<Restaurants> _state =
  ResultState(status: StatusState.loading, message: null, data: null);

  ResultState<Restaurants> get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState(status: StatusState.loading, message: null, data: null);
      notifyListeners();
      final restaurants = await apiService.getListRestaurant();
      if (restaurants.restaurants.isNotEmpty) {
        _state =
            ResultState(status: StatusState.hasData, message: null, data: restaurants);
        notifyListeners();
        return _state;
      } else {
        _state = ResultState(status: StatusState.noData, message: 'There are no restaurants', data: null);
        notifyListeners();
        return _state;
      }
    } on TimeoutException {
      _state = ResultState(status: StatusState.error, message: 'No Internet, Try Again!', data: null);
      notifyListeners();
      return _state;
    } on SocketException {
      _state = ResultState(
          status: StatusState.error, message: 'No Internet, Try Again!', data: null);
      notifyListeners();
      return _state;
    } catch (e) {
      _state = ResultState(status: StatusState.error, message: '$e Something went wrong', data: null);
      notifyListeners();
      return _state;
    }
  }
}