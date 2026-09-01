import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class Activity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListTile _followList(int num, String name, String place) {
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
              'https://api.dicebear.com/9.x/adventurer/png?seed=$name'),
          radius: 28.0,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        subtitle: Text(
          place,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 12.0,
          ),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: FaIcon(
            FontAwesomeIcons.userPlus,
            color: Colors.blueAccent,
            size: 19.0,
          ),
        ),
        onTap: () {
          Toast.show("Obunalar roʻyxati yangilandi!",
              duration: Toast.lengthShort, gravity: Toast.bottom);
        },
      );
    }

    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(10.0, 20.0, 3.0, 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 30.0,
                shadowColor: Colors.pink,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 20.0, 50.0, 15.0),
                  height: 101.0,
                  width: 169.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Yangi obunachilar',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Oxirgi 7 kun',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Metropolis',
                            fontSize: 10.0),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        '265',
                        style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.redAccent, Colors.orange],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),
            //Todo: Randomise Profile pics
            //Todo: Randomise Network images
            Expanded(
              child: Card(
                margin: EdgeInsets.fromLTRB(8.0, 20.0, 10.0, 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 30.0,
                shadowColor: Colors.blue,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 50.0, 10.0),
                  height: 101.0,
                  width: 162.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Obunani bekor qilganlar',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        'Oxirgi 7 kun',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Metropolis',
                            fontSize: 10.0),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        '82',
                        style: TextStyle(
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.white),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.blueAccent
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),
          ],
        ),
        _followList(Random().nextInt(10) + 1, 'Aziz', 'Toshkent'),
        _followList(Random().nextInt(10) + 1, 'Jasur', 'Samarqand'),
        _followList(Random().nextInt(10) + 1, 'Sardor', 'Buxoro'),
        _followList(Random().nextInt(10) + 1, 'Bekzod', 'Andijon'),
        _followList(Random().nextInt(10) + 1, 'Otabek', "Fargʻona"),
        _followList(Random().nextInt(10) + 1, 'Sherzod', 'Namangan'),
        _followList(Random().nextInt(10) + 1, 'Farrux', 'Xiva'),
        _followList(Random().nextInt(10) + 1, 'Javohir', 'Nukus'),
        _followList(Random().nextInt(10) + 1, "Ulugʻbek", 'Qarshi'),
        _followList(Random().nextInt(10) + 1, 'Rustam', 'Termiz'),
        _followList(Random().nextInt(10) + 1, 'Dilnoza', 'Jizzax'),
        _followList(Random().nextInt(10) + 1, 'Malika', 'Navoiy'),
        _followList(Random().nextInt(10) + 1, 'Nodira', 'Guliston'),
        _followList(Random().nextInt(10) + 1, 'Kamola', 'Urganch'),
        _followList(Random().nextInt(10) + 1, 'Zilola', "Margʻilon"),
        _followList(Random().nextInt(10) + 1, 'Gulnora', "Qoʻqon"),
        _followList(Random().nextInt(10) + 1, 'Madina', 'Chirchiq'),
        _followList(Random().nextInt(10) + 1, 'Nigora', 'Angren'),
        _followList(Random().nextInt(10) + 1, 'Sevara', 'Bekobod'),
      ],
    );
  }
}
