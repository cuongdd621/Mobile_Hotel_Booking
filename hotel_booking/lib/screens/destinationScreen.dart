import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/models/room.dart';
import 'package:hotel_booking/screens/hotelDetails.dart';
import 'package:hotel_booking/screens/listRoomsScreen.dart';
import '../models/destination_model.dart';
import '../models/hotel_model.dart';
import '../utils/utils.dart';
//import 'package:hotel_app/screens/hotelDetails.dart';

class DestinationScreen extends StatefulWidget {
  final Destination destination;
  DestinationScreen({required this.destination});
  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  List<Hotel> listHotel = [];

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  void asyncInitState() async {
    getHotelsByDestination(widget.destination.id)
        .then((value) => setState(() => listHotel = value));
  }

  Widget _buildRatingStars(double currentRating) {
    int integerPart = currentRating.toInt();
    double demicalPart = currentRating - integerPart;
    bool isHalfStar = demicalPart >= 0.5 ? true : false;
    int noStarPart = maxRatingStar - integerPart - (isHalfStar ? 1 : 0);

    var stars = [];
    var createStart = (IconData icon) => Icon(
          icon,
          color: Color.fromRGBO(251, 218, 75, 1),
          size: 16,
        );

    for (int i = 0; i < integerPart; i++) {
      stars.add(createStart(Icons.star));
    }

    if (isHalfStar) {
      stars.add(createStart(Icons.star_half_outlined));
    }

    for (int i = 0; i < noStarPart; i++) {
      stars.add(createStart(Icons.star_outline));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [...stars],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Hero(
                  tag: widget.destination.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.network(
                      widget.destination.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.destination.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.locationArrow,
                          size: 15.0,
                          color: Colors.white70,
                        ),
                        Text(
                          widget.destination.city,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 25.0,
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 10.0,
                bottom: 15.0,
              ),
              itemCount: listHotel.length,
              itemBuilder: (BuildContext context, int index) {
                Hotel hotel = listHotel[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetail(
                        hotel: hotel,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        height: 200.0,
                        // width: double.infinity,
                        width: 400.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(140.0, 20.0, 20.0, 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      hotel.name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      hotel.address,
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: _buildRatingStars(hotel.rating),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: hotel.rooms
                                          .map(
                                            (room) => Container(
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                room,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20.0,
                        top: 15.0,
                        bottom: 15.0,
                        child: Image.network(
                          hotel.imageUrl,
                          height: 180.0,
                          width: 120.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
