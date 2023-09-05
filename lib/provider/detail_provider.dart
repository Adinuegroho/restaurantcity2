import 'dart:async';
import 'dart:io';

import 'package:restaurantcity2/data/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:restaurantcity2/data/model/restaurant_detail.dart';
import 'package:restaurantcity2/utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  ResultState<RestaurantDetail> _state =
  ResultState(status: StatusState.loading, message: null, data: null);

  ResultState<RestaurantDetail> get state => _state;

  Future<dynamic> fetchRestaurantDetail(String id) async {
    try {
      _state = ResultState(status: StatusState.loading, message: null, data: null);
      notifyListeners();
      final restaurant = await apiService.getDetailRestaurant(id);
      if (restaurant.restaurant == null) {
        _state = ResultState(status: StatusState.noData, message: 'Empty Data', data: null);
        notifyListeners();
        return _state;
      } else {
        _state = ResultState(status: StatusState.hasData, message: null, data: restaurant);
        notifyListeners();
        return _state;
      }
    } on TimeoutException catch (e) {
      _state = ResultState(
          status: StatusState.error,
          message: 'Internet kamu lagi bermasalah coba periksa lagi!',
          data: null);
      notifyListeners();
      return _state;
    } on SocketException catch (e) {
      _state = ResultState(
          status: StatusState.error,
          message: 'Internet kamu lagi bermasalah coba periksa lagi!',
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