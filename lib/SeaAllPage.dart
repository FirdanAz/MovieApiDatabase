import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tv_movie/MoviePopulerModel.dart';
import 'package:tv_movie/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DetailPage.dart';

class SeaAllList extends StatefulWidget {
  const SeaAllList({Key? key}) : super(key: key);

  @override
  State<SeaAllList> createState() => _SeaAllListState();
}

class _SeaAllListState extends State<SeaAllList> {
  MoviePopuler? moviePopuler;
  MovieUpComming? movieUpComming;
  bool isloaded = true;

  void getAllListPL() async {
    setState(() {
      isloaded = false;
    });
    final res = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/upcoming?api_key=fba4f8e25e3a917422cc1659f99c670b&language=en-US"),
    );
    // print("status code " + res.statusCode.toString());
    moviePopuler = MoviePopuler.fromJson(json.decode(res.body.toString()));
    final res2 = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/top_rated?api_key=3fde454fd27493fe78341fbcabd51d11&language=en-US&page=1"),
    );
    // print("status code " + res2.statusCode.toString());
    movieUpComming = MovieUpComming.fromJson(json.decode(res2.body.toString()));
    setState(() {
      isloaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllListPL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorr.darkColor,
      appBar: AppBar(
        backgroundColor: Colorr.darkColor,
        title: Text('List Movie'),
      ),
      body: Center(
        child: Container(
          child: isloaded
              ? ListView.builder(
              itemCount: movieUpComming!.results!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return DetailPage(id: moviePopuler!.results![index].id!.toInt());
                        }
                        )
                    );
                  },
                  child: Column(
                    children: [
                      Card(
                        color: Colorr.darkColor,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 0.1))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 20),
                                      width: 70,
                                      height: 70,
                                      child: Image.network('https://themoviedb.org/t/p/w500/' +moviePopuler!.results![index].posterPath.toString(), fit: BoxFit.cover,)),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(moviePopuler!.results![index].title.toString(), style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

}