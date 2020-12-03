import 'package:wallpaper_app/Scraping/scraping.dart';
import 'package:wallpaper_app/SliderScreen/slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import '../SubCategoriesScreen/Sub_catagories.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
  Search({this.url, this.name});
 final String url;
 final String name;
}

class _SearchState extends State<Search> {
  ScrollController _scrollController = ScrollController();
  int i = 2;

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
    cscrap('https://wallpaperscraft.com/search/?order=&page=$i&query=${widget.name}&size=1080x1920')
        .then((data) {
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
    await Future.delayed(const Duration(microseconds: 300), () {
      cscrap(widget.url).then((data) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.name,
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
