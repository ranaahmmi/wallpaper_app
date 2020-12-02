import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black87,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 90,
                ),
                Container(
                    height: 300,
                    width: 300,
                    child: Center(
                      child: Text(
                        'Ez Wallpaper',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Version \n  1.0.0',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                    'EZ Wallpaper: Download, Save and Share \n All type of Wallpaper at any time\n\n',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('Contact Us',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('innovidio.apps@gmail.com',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
