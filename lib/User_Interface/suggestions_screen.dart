import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fntat/Components/constants.dart';

class Suggestions extends StatefulWidget {
  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions>
    with TickerProviderStateMixin {
  List<int> body = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

  bool isPlaying = false;
  bool isHome = true;
  bool isSearch = false;
  bool isPost = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: KHeaderColor,
          ),
          Positioned(
            top: 20.0,
            left: 20.0,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/nouserimagehandler.jpg"),
                  radius: 30.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "User Name",
                      style: KNameInHeaderStyle,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "User@email.com",
                      style: KNameInHeaderStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 25.0,
            right: 10.0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications,
                    color: KSubPrimaryColor,
                    size: 25.0,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.email,
                    color: KSubPrimaryColor,
                    size: 25.0,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 200.0,
            right: 0.0,
            left: 0.0,
            child: Container(
              height: screenSize.height - 200,
              // margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: KSubPrimaryColor,
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(
                  8.0,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  title: Text('${body[index]}'),
                  onTap: () {
                    print(body[index]);
                  },
                ),
                itemCount: body.length,
              ),
            ),
          ),
          Positioned(
            top: 150.0,
            right: 40.0,
            left: 95.0,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: isSearch ? 100.0 : 80.0,
                  width: isSearch ? 80.0 : 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: KPrimaryColor,
                    ),
                    color: KSubPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                        isHome = false;
                        isPost = false;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: isSearch ? KPrimaryColor : KSubSecondryFontsColor,
                      size: isSearch ? 40.0 : 30.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: isHome ? 100.0 : 80.0,
                  width: isHome ? 80.0 : 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: KPrimaryColor,
                    ),
                    color: KSubPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isHome = true;
                        isSearch = false;
                        isPost = false;
                      });
                    },
                    icon: Icon(
                      Icons.home,
                      color: isHome ? KPrimaryColor : KSubSecondryFontsColor,
                      size: isHome ? 40.0 : 30.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: isPost ? 100.0 : 80.0,
                  width: isPost ? 80.0 : 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: KPrimaryColor,
                    ),
                    color: KSubPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isPost = true;
                        isHome = false;
                        isSearch = false;
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color: isPost ? KPrimaryColor : KSubSecondryFontsColor,
                      size: isPost ? 40.0 : 30.0,
                    ),
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
