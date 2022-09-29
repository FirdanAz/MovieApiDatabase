import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tv_movie/now_playing_api.dart';
import 'package:tv_movie/DetailPage.dart';
import 'package:tv_movie/MoviePopulerModel.dart';
import 'package:tv_movie/SideBar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tv_movie/SeaAllPage.dart';
import 'package:tv_movie/theme.dart';
import 'package:shimmer/shimmer.dart';

class ListMoviePopuler extends StatefulWidget {
  const ListMoviePopuler({Key? key}) : super(key: key);

  @override
  State<ListMoviePopuler> createState() => _ListMoviePopulerState();
}

class _ListMoviePopulerState extends State<ListMoviePopuler> {
  MoviePopuler? moviePopuler;
  MovieUpComming? movieUpComming;
  MovieTopRated? movieTopRated;
  String? image;
  bool isloaded = true;

  void getAllListM() async {
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

    final res3 = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?api_key=3fde454fd27493fe78341fbcabd51d11&language=en-US&page=1"),
    );
    // print("status code " + res2.statusCode.toString());
    movieTopRated = MovieTopRated.fromJson(json.decode(res3.body.toString()));
    setState(() {
      isloaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllListM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      backgroundColor: Colorr.darkColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: Builder(builder: (context) => IconButton(onPressed: (){
                  Scaffold.of(context).openDrawer();
                }, icon: Icon(Icons.menu_open))),
                expandedHeight: 60,
                backgroundColor: Colorr.darkColor,
                floating: false,
                pinned: true,
                title: Center(child: Text('MOVIE'),),
                actions: [
                  Padding(padding: EdgeInsets.all(16), child: Icon(Icons.search))
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colorr.darkColor,
                    child: SizedBox(
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 20, left: 20, bottom: 15),
                          child: Text("TOP POPULER", style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                ),
              ),
              SliverToBoxAdapter(
                child: isloaded ? CarouselSlider.builder(
                    itemCount: moviePopuler!.results!.length,
                    options: CarouselOptions(
                      height: 370,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlay: true,
                    ),
                    itemBuilder: (context, index, realIndex){
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return DetailPage(id: moviePopuler!.results![index].id!.toInt());
                              }
                              )
                          );
                        },
                        child: Container(
                          width: 290,
                          color: Colors.black12,
                          margin: EdgeInsets.all(5),
                          child: Container(
                            child: FittedBox(
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/Eclipse-Loading.gif',
                                  image: 'https://themoviedb.org/t/p/w500/' +moviePopuler!.results![index].posterPath.toString()),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
                ): Image.asset('assets/Eclipse-Loading.gif')
              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("UP COMMING", style: TextStyle(color: Colors.white, fontSize: 14)),
                        InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SeaAllList();
                                  }
                                  )
                              );
                            },
                            child: Text("See All", style: TextStyle(color: Colors.white54, fontSize: 10))
                        ),
                      ],
                    )
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: SizedBox(
                            height: 200,
                            child: isloaded ? ListView.builder(
                              itemCount: movieUpComming!.results!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return DetailPage(id: movieUpComming!.results![index].id!.toInt());
                                        }
                                        )
                                    );
                                  },
                                  child: Card(
                                    color: Colorr.darkColor,
                                    child: Container(
                                      margin: EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          child: FadeInImage.assetNetwork(placeholder: 'assets/Eclipse-Loading.gif', width: 140,placeholderCacheWidth: 50, image: "https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieUpComming!.results![index].posterPath.toString(), fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ): null
                        ),
                      )
                    ],
                  ),
                ),

              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("TOP RATED", style: TextStyle(color: Colors.white, fontSize: 14)),
                        InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SeaAllList();
                                  }
                                  )
                              );
                            },
                            child: Text("See All", style: TextStyle(color: Colors.white54, fontSize: 10))
                        ),
                      ],
                    )
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: SizedBox(
                            height: 200,
                            child: isloaded ? ListView.builder(
                              itemCount: moviePopuler!.results!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return DetailPage(id: moviePopuler!.results![index].id!.toInt());
                                        }
                                        )
                                    );
                                  },
                                  child: Card(
                                    color: Colorr.darkColor,
                                    child: Container(
                                      margin: EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          child: FadeInImage.assetNetwork(placeholder: 'assets/Eclipse-Loading.gif', width: 140,placeholderCacheWidth: 50, image: "https://www.themoviedb.org/t/p/w220_and_h330_face/"+moviePopuler!.results![index].posterPath.toString(), fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ): null
                        ),
                      )
                    ],
                  ),
                ),

              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: 20,left: 20,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("NOW PLAYING", style: TextStyle(color: Colors.white, fontSize: 14)),
                        InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return SeaAllList();
                                  }
                                  )
                              );
                            },
                            child: Text("See All", style: TextStyle(color: Colors.white54, fontSize: 10))
                        ),
                      ],
                    )
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: SizedBox(
                            height: 200,
                            child: isloaded ? ListView.builder(
                              itemCount: movieTopRated!.results!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return DetailPage(id: movieTopRated!.results![index].id!.toInt());
                                        }
                                        )
                                    );
                                  },
                                  child: Card(
                                    color: Colorr.darkColor,
                                    child: Container(
                                      margin: EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          child: FadeInImage.assetNetwork(placeholder: 'assets/Eclipse-Loading.gif', width: 140,placeholderCacheWidth: 50, image: "https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieTopRated!.results![index].posterPath.toString(), fit: BoxFit.fill,),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ): null
                        ),
                      )
                    ],
                  ),
                ),

              ),
            ]
        ),
      ),
    );
  }
}
