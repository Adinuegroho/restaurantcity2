import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity2/data/model/restaurants.dart';
import 'package:restaurantcity2/provider/home_provider.dart';
import 'package:restaurantcity2/ui/detail_screen.dart';
import 'package:restaurantcity2/utils/result_state.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.blue,
        title: const Text('Restaurant App'),
      ),
      body: MainMobile()
    );
  }
}

class MainMobile extends StatelessWidget {
  const MainMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, state, _) {
        ResultState<Restaurants> result = state.state;
        switch (result.status) {
          case StatusState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case StatusState.noData:
            return Center(
              child: Text('Empty Data : ${result.message}'),
            );
          case StatusState.hasData:
            return ListView.builder(
              itemCount: result.data!.restaurants.length,
              itemBuilder: (context, index) =>
                  _buildItem(context, result.data!.restaurants[index]),
            );
          case StatusState.error:
            return Center(
              child: Text(result.message!),
            );
          default:
            return const Center(
              child: Text('Error'),
            );
        }
      },
    );
  }

  Widget _buildItem(BuildContext context, RestaurantsElement restaurantsElement) {
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
                                  color: Colors.black54, fontSize: 12.0),
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
