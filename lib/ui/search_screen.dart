import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity2/data/model/restaurant_search.dart';
import 'package:restaurantcity2/data/model/restaurants.dart';
import 'package:restaurantcity2/provider/search_provider.dart';
import 'package:restaurantcity2/ui/detail_screen.dart';
import 'package:restaurantcity2/utils/result_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const routeName = '/restaurant_search_page';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.blue,
        title: const Text('Restaurant App'),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, state, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search Restaurant',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onChanged: (String text) {
                    setState(() {
                      state.fetchRestaurantSearch(text);
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildList(context),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildList(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, state, _) {
        ResultState<RestaurantSearch> result = state.state;
        switch (result.status) {
          case StatusState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case StatusState.hasData:
            return ListView.builder(
              itemCount: result.data!.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = result.data!.restaurants[index];
                return _buildRestoItem(context, restaurant);
              },
            );
          case StatusState.noData:
            return const Center(
              child: Text('Restaurant not found'),
            );
          case StatusState.textFieldEmpty:
            return const Center(
              child: Text('Input name restaurant'),
            );
          case StatusState.error:
            return Center(
              child: Text('Error : ${result.message}'),
            );
          default:
            return const Center(
              child: Text(''),
            );
        }
      },
    );
  }

  _buildRestoItem(BuildContext context, RestaurantsElement restaurantsElement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, DetailScreen.routeName, arguments: restaurantsElement.id);
        },
        child: SizedBox(
          height: 100,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Hero(
                    tag: restaurantsElement.pictureId,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                      child: Image.network("https://restaurant-api.dicoding.dev/images/small/${restaurantsElement.pictureId}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 15.0, 2.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantsElement.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_sharp,
                              size: 14,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              restaurantsElement.city,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 12),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xffFFC41F),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              restaurantsElement.rating.toString(),
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
