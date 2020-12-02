import 'package:wallpaper_app/Pages/scraping.dart';
import 'package:wallpaper_app/Pages/slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/Pages/Shared_preferences.dart';

class SubCategories extends StatefulWidget {
  static const routeName = '/Sub_Categories';
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  ScrollController _scrollController = ScrollController();
  int i = 2;
  static String url = '';

  @override
  void initState() {
    loaddata();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadAgain();
      }
    });
    super.initState();
  }

  void _loadAgain() {
    cscrap(url + '/page$i').then((data) {
      setState(() {
        i++;
      });
    });
  }

  @override
  void dispose() {
    categorieslist = [];
    super.dispose();
  }

  loaddata() async {
    await Future.delayed(const Duration(seconds: 1), () {
      cscrap(url).then((data) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map urls = ModalRoute.of(context).settings.arguments;
    setState(() {
      url = urls['url'];
    });
    return Scaffold(
      appBar: AppBar(title: Text('EZ Wallpaper')),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  urls['name'],
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height*0.9,
                  child: wallpaper())
            ],
          ),
        ),
      ),
    );
  }

  wallpaper() {
    return categorieslist.length > 0
        ? GridView.builder(
            controller: _scrollController,
            itemCount: categorieslist.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.2),
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index == categorieslist.length) {
                return CupertinoActivityIndicator();
              }
              final wallpaper = categorieslist[index];
              return GestureDetector(
                onTap: () {
                  Pref().adsetData();
                  Pref().adsaveData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Sliders(
                              page: index,
                              lists: categorieslist,
                            )),
                  );
                },
                child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Image.network(
                      wallpaper['src'],
                      fit: BoxFit.fitWidth,
                    )),
              );
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

var categorieslist = [];
