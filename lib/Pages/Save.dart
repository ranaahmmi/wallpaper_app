

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/Pages/Shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Preview.dart';

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
  }

  sharepref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favlist = prefs.getStringList('favlist') ?? [];
    });
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
                  height: MediaQuery.of(context).size.height*0.9,
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
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.2),
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Pref().adsetData();
                  Pref().adsaveData();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Preview(
                            src: favlist[index],
                          )));
                },
                child: Container(
                    padding: const EdgeInsets.all(2),
                    child: Image.network(
                      favlist[index],
                      fit: BoxFit.fitWidth,
                    )),
              );
            })
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
