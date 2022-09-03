import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tv_movie/DetailPage.dart';
import 'package:tv_movie/MoviePopulerModel.dart';
import 'package:tv_movie/SideBar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ListMoviePopuler extends StatefulWidget {
  const ListMoviePopuler({Key? key}) : super(key: key);

  @override
  State<ListMoviePopuler> createState() => _ListMoviePopulerState();
}

class _ListMoviePopulerState extends State<ListMoviePopuler> {
  MoviePopuler? moviePopuler;
  MovieUpComming? movieUpComming;
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
      backgroundColor: Colors.black54,
      body:
      isloaded ? SafeArea(
        child:
        Container(
          child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  backgroundColor: Colors.black,
                  floating: false,
                  pinned: true,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Color.fromARGB(255, 7, 0, 21),
                      child: ImageSlideshow(
                          children: [
                            Container(
                                child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/loading.gif',
                                    image: 'https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_3x/sources/r1/cms/prod/3323/1313323-h-f9adecb3ddf1'
                                )
                            ),
                            Image.network("https://img1.hotstarext.com/image/upload/f_auto,t_web_hs_3x/sources/r1/cms/prod/5059/1035059-h-7cabccff379c"),
                            Image.network("https://assets.jalantikus.com/assets/cache/769/330/ragam/2022/08/02/pesulap-merah-vs-gus-samsudin-46d47.jpg"),
                          ],
                          autoPlayInterval: 5000,
                        isLoop: true,
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
                            Text("TOP POPULER", style: TextStyle(color: Colors.white, fontSize: 14)),
                            InkWell(
                              onTap: (){},
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
                                          return DetailPage(movie: moviePopuler!.results![index]);
                                        }
                                        )
                                    );
                                  },
                                  child: Card(
                                    color: Color.fromARGB(255, 24, 24, 24),
                                    child: Container(
                                      margin: EdgeInsets.all(1.0),
                                      child: Container(
                                        child: FadeInImage.assetNetwork(placeholder: 'assets/loading.gif', width: 140,placeholderCacheWidth: 50, image: "https://www.themoviedb.org/t/p/w220_and_h330_face/"+moviePopuler!.results![index].posterPath.toString()),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ): CircularProgressIndicator()
                          ),
                        )
                      ],
                    ),
                  ),

                ),
                SliverToBoxAdapter(
                  child: Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Up Comming", style: TextStyle(color: Colors.white, fontSize: 14)),
                          InkWell(
                              onTap: (){},
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
                            child: ListView.builder(
                              itemCount: movieUpComming!.results!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return DetailPage(movie: movieUpComming!.results![index]);
                                        }
                                        )
                                    );
                                  },
                                  child: Card(
                                    color: Color.fromARGB(255, 24, 24, 24),
                                    child: Container(
                                      margin: EdgeInsets.all(1.0),
                                      child: Image.network("https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieUpComming!.results![index].posterPath.toString()),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                ),
                SliverToBoxAdapter(
                  child: Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TOP POPULER", style: TextStyle(color: Colors.white, fontSize: 14)),
                          InkWell(
                              onTap: (){},
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
                                          return DetailPage(movie: moviePopuler!.results![index]);
                                        }
                                        )
                                    );
                                  },
                                  child: Card(
                                    color: Color.fromARGB(255, 24, 24, 24),
                                    child: Container(
                                      margin: EdgeInsets.all(1.0),
                                      child: Image.network("https://www.themoviedb.org/t/p/w220_and_h330_face/"+moviePopuler!.results![index].posterPath.toString()),
                                    ),
                                  ),
                                );
                              },
                            ): CircularProgressIndicator()
                          ),
                        )
                      ],
                    ),
                  ),

                ),
              ]
          ),
        )
      ): Center(child: CircularProgressIndicator())
    );
  }
}
