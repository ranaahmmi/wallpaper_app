import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wallpaper_app/Shared/Shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../PreviewScreen/Preview.dart';

class Save extends StatefulWidget {
  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  @override
  void initState() {
    sharepref();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    savepref();
  }

  sharepref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favlist = prefs.getStringList('favlist') ?? [];
    });
  }

  savepref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favlist', favlist);
  }

  List<String> favlist = [];

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
                  'Faviorit',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: wallpaper())
            ],
          ),
        ),
      ),
    );
  }

  wallpaper() {
    return favlist.length > 0
        ? GridView.builder(
            itemCount: favlist.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              childAspectRatio: 0.56
            ),
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                children: [
                  GestureDetector(
                      onTap: () {
                        Pref().adsetData();
                        Pref().adsaveData();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Preview(
                                  src: favlist[index],
                                )));
                      },
                      child: CachedNetworkImage(
                        imageUrl: favlist[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: SpinKitCubeGrid(
                            color: Colors.white,
                            size: 35.0,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )),
                  Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red[900],
                      )).onTap(() {
                    setState(() {
                      print('tab');
                      favlist.removeAt(index);
                    });
                  })
                ],
              );
            })
        : Center(
            child: 'No Favourite Found'.text.white.bold.xl2.makeCentered(),
          );
  }
}
