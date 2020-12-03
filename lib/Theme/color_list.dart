import 'package:wallpaper_app/SearchScreen/Search.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorList extends StatefulWidget {
  @override
  _ColorListState createState() => _ColorListState();
}

class _ColorListState extends State<ColorList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Pref().adsetData();
              Pref().adsaveData();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Search(
                        url: colorList[index]['url'],
                        name: colorList[index]['name'],
                      )));
            },
            child: Container(
              height: 50,
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                  image: AssetImage(colorList[index]['picture']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Text(
                colorList[index]['name'],
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
            ),
          );
        });
  }

  var colorList = [
    {
      'name': 'Silver',
      'picture': 'assets/Silver.png',
      'url': 'https://wallpaperscraft.com/search/?query=silver&size=1080x1920'
    },
    {
      'name': 'Red',
      'picture': 'assets/Red.webp',
      'url': 'https://wallpaperscraft.com/search/?query=red&size=1080x1920'
    },
    {
      'name': 'Purple',
      'picture': 'assets/Purple.png',
      'url': 'https://wallpaperscraft.com/search/?query=purple&size=1080x1920'
    },
    {
      'name': 'Yellow',
      'picture': 'assets/Yellow.png',
      'url': 'https://wallpaperscraft.com/search/?query=yellow&size=1080x1920'
    },
    {
      'name': 'Green',
      'picture': 'assets/Green.png',
      'url': 'https://wallpaperscraft.com/search/?query=green&size=1080x1920'
    },
    {
      'name': 'Blue',
      'picture': 'assets/Blue.png',
      'url': 'https://wallpaperscraft.com/search/?query=blue&size=1080x1920'
    },
    {
      'name': 'White',
      'picture': 'assets/White.webp',
      'url': 'https://wallpaperscraft.com/search/?query=white&size=1080x1920'
    },
    {
      'name': 'Black',
      'picture': 'assets/Black.png',
      'url': 'https://wallpaperscraft.com/search/?query=black&size=1080x1920'
    },
    {
      'name': 'Pink',
      'picture': 'assets/Pink.png',
      'url': 'https://wallpaperscraft.com/search/?query=pink&size=1080x1920'
    },
    {
      'name': 'Grey',
      'picture': 'assets/Grey.png',
      'url': 'https://wallpaperscraft.com/search/?query=grey&size=1080x1920'
    },
    {
      'name': 'Brown',
      'picture': 'assets/Brown.png',
      'url': 'https://wallpaperscraft.com/search/?query=brown&size=1080x1920'
    },
  ];
}
