import 'package:restaurantcity2/data/model/restaurants.dart';

class RestaurantSearch {
  RestaurantSearch({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool error;
  int founded;
  List<RestaurantsElement> restaurants;

  factory RestaurantSearch.fromJson(Map<String, dynamic> json) =>
      RestaurantSearch(
        error: json["error"],
        founded: json["founded"],
        restaurants: (json["restaurants"] as List)
            .map((x) => RestaurantsElement.fromJson(x))
            .toList(),
      );
}