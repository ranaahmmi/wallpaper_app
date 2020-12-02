import 'package:wallpaper_app/Pages/Sub_catagories.dart';
import 'package:wallpaper_app/Pages/color_list.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/Pages/Shared_preferences.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Colors',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ColorList(),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.66,
                    child: GridView.builder(
                        itemCount: pictureList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 3),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final wallpaper = pictureList[index];
                          return GestureDetector(
                            onTap: () {
                              Pref().adsetData();
                              Pref().adsaveData();
                              Navigator.of(context).pushNamed(
                                  SubCategories.routeName,
                                  arguments: wallpaper);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  colorFilter: new ColorFilter.mode(
                                      Colors.black.withOpacity(0.7),
                                      BlendMode.dstATop),
                                  image: AssetImage(wallpaper['picture']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                pictureList[index]['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              )),
                            ),
                          );
                        }))
              ],
            )));
  }

  final List pictureList = [
    {
      'name': '3D',
      'picture': 'assets/threed.png',
      'url': 'https://wallpaperscraft.com/catalog/3d/1080x1920'
    },
    {
      'name': '60 Favorites',
      'picture': 'assets/fav.png',
      'url': 'https://wallpaperscraft.com/catalog/60_favorites/1080x1920'
    },
    {
      'name': 'Abstract',
      'picture': 'assets/abstract.png',
      'url': 'https://wallpaperscraft.com/catalog/abstract/1080x1920'
    },
    {
      'name': 'Animals',
      'picture': 'assets/animals.png',
      'url': 'https://wallpaperscraft.com/catalog/animals/1080x1920'
    },
    {
      'name': 'Anime',
      'picture': 'assets/animated.png',
      'url': 'https://wallpaperscraft.com/catalog/anime/1080x1920'
    },
    {
      'name': 'Art',
      'picture': 'assets/art.png',
      'url': 'https://wallpaperscraft.com/catalog/art/1080x1920'
    },
    {
      'name': 'Black',
      'picture': 'assets/black.png',
      'url': 'https://wallpaperscraft.com/catalog/black/1080x1920'
    },
    {
      'name': 'Cars',
      'picture': 'assets/cars.png',
      'url': 'https://wallpaperscraft.com/catalog/cars/1080x1920'
    },
    {
      'name': 'City',
      'picture': 'assets/city.png',
      'url': 'https://wallpaperscraft.com/catalog/city/1080x1920'
    },
    {
      'name': 'Dark',
      'picture': 'assets/dark.png',
      'url': 'https://wallpaperscraft.com/catalog/dark/1080x1920'
    },
    {
      'name': 'Fantasy',
      'picture': 'assets/fantasy.png',
      'url': 'https://wallpaperscraft.com/catalog/fantasy/1080x1920'
    },
    {
      'name': 'Flowers',
      'picture': 'assets/flowers.png',
      'url': 'https://wallpaperscraft.com/catalog/flowers/1080x1920'
    },
    {
      'name': 'Food',
      'picture': 'assets/food.png',
      'url': 'https://wallpaperscraft.com/catalog/food/1080x1920'
    },
    {
      'name': 'Holidays',
      'picture': 'assets/holidays.png',
      'url': 'https://wallpaperscraft.com/catalog/holidays/1080x1920'
    },
    {
      'name': 'Love',
      'picture': 'assets/love.png',
      'url': 'https://wallpaperscraft.com/catalog/love/1080x1920'
    },
    {
      'name': 'Macro',
      'picture': 'assets/macro.png',
      'url': 'https://wallpaperscraft.com/catalog/marco/1080x1920'
    },
    {
      'name': 'Minimalism',
      'picture': 'assets/minimalism.png',
      'url': 'https://wallpaperscraft.com/catalog/minimalism/1080x1920'
    },
    {
      'name': 'Motorcycle',
      'picture': 'assets/motorcycle.png',
      'url': 'https://wallpaperscraft.com/catalog/motorcycles/1080x1920'
    },
    {
      'name': 'Music',
      'picture': 'assets/music.png',
      'url': 'https://wallpaperscraft.com/catalog/music/1080x1920'
    },
    {
      'name': 'Nature',
      'picture': 'assets/nature.png',
      'url': 'https://wallpaperscraft.com/catalog/nature/1080x1920'
    },
    {
      'name': 'Other',
      'picture': 'assets/other.png',
      'url': 'https://wallpaperscraft.com/catalog/other/1080x1920'
    },
    {
      'name': 'Space',
      'picture': 'assets/space.png',
      'url': 'https://wallpaperscraft.com/catalog/space/1080x1920'
    },
    {
      'name': 'Sports',
      'picture': 'assets/sports.png',
      'url': 'https://wallpaperscraft.com/catalog/sport/1080x1920'
    },
    {
      'name': 'Technologies',
      'picture': 'assets/technologies.png',
      'url': 'https://wallpaperscraft.com/catalog/technologies/1080x1920'
    },
    {
      'name': 'Textures',
      'picture': 'assets/textures.png',
      'url': 'https://wallpaperscraft.com/catalog/textures/1080x1920'
    },
    {
      'name': 'Vector',
      'picture': 'assets/vector.png',
      'url': 'https://wallpaperscraft.com/catalog/vector/1080x1920'
    },
    {
      'name': 'Words',
      'picture': 'assets/words.png',
      'url': 'https://wallpaperscraft.com/catalog/words/1080x1920'
    },
  ];
}
