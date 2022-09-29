import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tv_movie/theme.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colorr.darkColor,
      width: 60,
      child: Container(
        margin: EdgeInsets.only(top: 230),
        child: Column(
          children: [
            InkWell(
              onTap: (){},
              child: Card(
                color: Colorr.darkColor,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(Icons.history, color: Colors.white,),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Card(
                color: Colorr.darkColor,
                child: Container(
                  alignment: Alignment.center,
                  width: 190,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(Icons.sunny, color: Colors.white,),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){},
              child: Card(
                color: Colorr.darkColor,
                child: Container(
                  alignment: Alignment.center,
                  width: 190,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Icon(Icons.settings, color: Colors.white,),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
