import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(
                      'Ez Wallpaper',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Privacy Policies\n',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(
                          ' * ' +
                              ' Innovidio App EZ Wallpaper App would not collect any user registration data either at the time of download or later when the user is using the application \n\n' +
                              '*' +
                              ' Innovidio App EZ Wallpaper App would not use the user location or access the user camera\n\n' +
                              '*' +
                              ' Innovidio App EZ Wallpaper App would not send the user files or folders to any central server\n\n' +
                              '*' +
                              ' Innovidio App EZ Wallpaper App would not let any 3rd party app or plugin collect the user data through the EZ Translator App',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
