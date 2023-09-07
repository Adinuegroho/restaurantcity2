import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurantcity2/data/model/restaurant_detail.dart';
import 'package:restaurantcity2/data/model/restaurant_search.dart';
import '../model/restaurants.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<Restaurants> getListRestaurant() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return Restaurants.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load list restaurant');
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse("${_baseUrl}detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetail.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load list restaurant');
    }
  }

  Future<RestaurantSearch> getSearchRestaurants(String query) async {
    final response = await http.get(Uri.parse('${_baseUrl}search?q=$query'));
    if(response.statusCode == 200) {
      return RestaurantSearch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant search');
    }
  }
}