import 'dart:ffi';

import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 24, 24, 24),
      width: 60,
      child: Container(
        margin: EdgeInsets.only(top: 230),
        child: Column(
          children: [
            InkWell(
              onTap: (){},
              child: Card(
                color: Color.fromARGB(255, 24, 24, 24),
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
                color: Color.fromARGB(255, 24, 24, 24),
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
                color: Color.fromARGB(255, 24, 24, 24),
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
