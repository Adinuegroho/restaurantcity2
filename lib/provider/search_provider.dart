import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:restaurantcity2/data/api/api_service.dart';
import 'package:restaurantcity2/data/model/restaurant_search.dart';
import 'package:restaurantcity2/utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService}) {
    fetchRestaurantSearch(query);
  }

  ResultState<RestaurantSearch> _state = ResultState(
      status: StatusState.hasData,
      message: null,
      data: RestaurantSearch(
        error: false,
        founded: 0,
        restaurants: [],
      ));

  String _query = '';

  ResultState<RestaurantSearch> get state => _state;

  String get query => _query;

  Future<dynamic> fetchRestaurantSearch(String query) async {
    try {
      _state =
          ResultState(status: StatusState.loading, message: null, data: null);
      _query = query;
      notifyListeners();
      if (_query != '') {
        final restaurant = await apiService.getSearchRestaurants(query);
        if (restaurant.restaurants.isEmpty) {
          _state = ResultState(
              status: StatusState.noData, message: 'Empty Data', data: null);
          notifyListeners();
          return _state;
        } else {
          _state = ResultState(
              status: StatusState.hasData, message: null, data: restaurant);
          notifyListeners();
          return _state;
        }
      } else {
        _state = ResultState(
            status: StatusState.textFieldEmpty,
            message: 'Find ur favorite restaurant',
            data: null);
        notifyListeners();
        return _state;
      }
    } on TimeoutException {
      _state = ResultState(
          status: StatusState.error,
          message: 'No Internet, Try Again!',
          data: null);
      notifyListeners();
      return _state;
    } on SocketException {
      _state = ResultState(
          status: StatusState.error,
          message: 'No Internet, Try Again!',
          data: null);
      notifyListeners();
      return _state;
    } catch (e) {
      _state = ResultState(
          status: StatusState.error, message: 'Error --> $e', data: null);
      notifyListeners();
      return _state;
    }
  }
}