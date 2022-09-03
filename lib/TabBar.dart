import 'package:flutter/material.dart';
import 'package:tv_movie/ListMoviePopuler.dart';

class TabbarExample extends StatefulWidget {
  const TabbarExample({Key? key}) : super(key: key);

  @override
  State<TabbarExample> createState() => _TabbarExampleState();
}

class _TabbarExampleState extends State<TabbarExample>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(icon: Text('FootBall')),
    Tab(icon: Text('Kontak')),
    Tab(icon: Text('Panggilan')),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          bottom: TabBar(
            onTap: (ListSiswa) {},
            controller: _controller,
            tabs: list,
          ),
          title: Center(
            child: Text('API'),
          ),
        ),
        body: TabBarView(controller: _controller, children: [
          ListMoviePopuler(),
          Center(
          ),
          Center(
              child: Text(
                _selectedIndex.toString(),
                style: TextStyle(fontSize: 40),
              )),
        ]),
      ),
    );
  }
}