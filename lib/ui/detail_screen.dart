import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantcity2/data/model/restaurant_detail.dart';
import 'package:restaurantcity2/data/model/restaurants.dart';
import 'package:restaurantcity2/provider/detail_provider.dart';
import 'package:restaurantcity2/utils/result_state.dart';

class DetailScreen extends StatefulWidget {
  static const routeName = '/detail_screen';
  final String restoId;

  const DetailScreen({Key? key, required this.restoId}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 75,
        backgroundColor: Colors.blue,
        foregroundColor: const Color(0xff333740),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Detail Restaurant",
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: DetailMainMobile(restoId: widget.restoId)
    );
  }
}

class DetailMainMobile extends StatefulWidget {

  final String restoId;
  const DetailMainMobile({Key? key, required this.restoId}) : super(key: key);

  @override
  State<DetailMainMobile> createState() => _DetailMainMobileState();
}

class _DetailMainMobileState extends State<DetailMainMobile> {

  @override
  void initState() {
    Future.microtask(() {
      DetailProvider provider = Provider.of<DetailProvider>(
        context,
        listen: false,
      );
      provider.fetchRestaurantDetail(widget.restoId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return Consumer<DetailProvider>(
        builder: (context, state, _) {
          ResultState<RestaurantDetail> result = state.state;
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
              RestaurantsElement restaurant = result.data!.restaurant;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(
                          color: const Color(0xffF4F4F4),
                          width: double.infinity,
                          child: Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(14.0),
                                  bottomRight: Radius.circular(14.0),
                                ),
                                child: Image.network("https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}",
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30,
                                              color: Color(0xff333740)),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_sharp,
                                              color: Colors.red,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              restaurant.city,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff828285)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xffFFC41F),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        restaurant.rating.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff333740)
                                        ),
                                      )
                                    ],
                                  )

                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                "Description",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff333740)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                restaurant.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff828285)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 16.0, 0.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Foods',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: restaurant.menus.foods.map(
                                        (menu) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: const DecorationImage(
                                                image: NetworkImage('https://picsum.photos/id/493/200/300'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  menu.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Drinks',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: restaurant.menus.drinks.map(
                                        (menu) {
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 10),
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              image: const DecorationImage(
                                                image: NetworkImage('https://picsum.photos/id/755/200/300'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black.withOpacity(0.5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  menu.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
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
}




