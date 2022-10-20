import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_movie/Database/database_model.dart';
import 'package:tv_movie/Database/movie_database.dart';
import 'package:tv_movie/MoviePopulerModel.dart';
import 'package:tv_movie/movie_detail_api.dart';
import 'package:tv_movie/movie_video_api.dart';
import 'package:tv_movie/now_playing_api.dart';
import 'package:tv_movie/SeaAllPage.dart';
import 'package:tv_movie/theme.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Database/database_model.dart';
import 'package:path/path.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  MovieVideoApi? movieVideoApi;
  MovieDetail? movieDetail;
  MoviePopuler? moviePopuler;
  MovieModel? movieModel;
  bool isloaded = false;
  List<MovieModel> dataListMovie = [];

  var database;
  bool isFavorit = false;

  Future<void> AddListDetail() async {
    setState(() {
      isloaded = false;
    });
    final res = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/${widget.id.toString()}/videos?api_key=3fde454fd27493fe78341fbcabd51d11&language=en-US"),
    );
    movieVideoApi = MovieVideoApi.fromJson(json.decode(res.body.toString()));

    final res2 = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/${widget.id.toString()}?api_key=3fde454fd27493fe78341fbcabd51d11&language=en-US"),
    );
    movieDetail = MovieDetail.fromJson(json.decode(res2.body.toString()));
    final res3 = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/top_rated?api_key=3fde454fd27493fe78341fbcabd51d11&language=en-US&page=1"),
    );
    moviePopuler = MoviePopuler.fromJson(json.decode(res3.body.toString()));

    dataListMovie = await MovieDatabase.instance.readAll();

    setState(() {
      isloaded = true;
    });
    for (var i =0;i<dataListMovie.length; i++) {
      print(dataListMovie[i].name);
      print(movieDetail!.title);
      if (dataListMovie[i].name == movieDetail!.title) {
        isFavorit = true;
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddListDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colorr.darkColor,
        body: isloaded ? CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                actions: [
                    IconButton(onPressed: () async {
                      setState(() {
                        isFavorit = !isFavorit;
                      });
                      if(isFavorit == true){
                        var karyawan;
                        karyawan = MovieModel(
                            imagePath: "https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieDetail!.posterPath.toString(),
                            name: movieDetail!.originalTitle.toString(),
                            idMovie: movieDetail!.id.toString());
                        await MovieDatabase.instance.create(karyawan);
                        Navigator.pop(context, "result");
                        final snackBar = SnackBar(
                          content: const Text('Movie Disimpan!!'),
                          backgroundColor: (Colors.black),
                          action: SnackBarAction(
                            label: 'Oke',
                            onPressed: () {
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                        await MovieDatabase.instance.delete(movieDetail!.title.toString());
                      }
                    }, icon: isFavorit ? Icon(Icons.favorite, color: Colors.white,) : Icon(Icons.favorite_border, color: Colors.white,)),
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.maxFinite,
                      color: Colorr.darkColor,
                      child: Center(
                        child: Text(
                          movieDetail!.originalTitle.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pinned: true,
                backgroundColor: Colors.black87,
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  background: InkWell(
                    onTap: () async {},
                    child: ColorFiltered(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage("https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieDetail!.backdropPath.toString()), fit: BoxFit.cover),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                          child: Center(
                              child: Image.network(
                                "https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieDetail!.posterPath.toString(), height: 250,
                              ),
                          ),
                        ),
                      ),
                      colorFilter: ColorFilter.mode(Colors.black38, BlendMode.color),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colorr.darkColor,
                  margin: EdgeInsets.only(bottom: 200),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          movieDetail!.overview.toString(),
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                              border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 0.1))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 320,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Name  : '+movieDetail!.title!.toString(), style: TextStyle(color: Colors.white70),),
                                      Text('Release Date  : '+movieDetail!.releaseDate!.toString(), style: TextStyle(color: Colors.white70),),
                                      Container(width: 350, child: Text('Status  : '+movieDetail!.status!.toString(),overflow: TextOverflow.clip, style: TextStyle(color: Colors.white70),)),
                                      Text('Popularity : '+movieDetail!.popularity.toString(), style: TextStyle(color: Colors.white70),)
                                    ],
                                  ),
                                ),
                                InkWell(
                                  child: Icon(Icons.star,color: Colors.grey, size: 25,),
                                  onTap: () async {
                                    String? namaa = movieDetail!.id.toString();
                                    var karyawan;
                                    karyawan = MovieModel(
                                        imagePath: "https://www.themoviedb.org/t/p/w220_and_h330_face/"+movieDetail!.posterPath.toString(),
                                        name: movieDetail!.originalTitle.toString(),
                                        idMovie: movieDetail!.id.toString());
                                    await MovieDatabase.instance.create(karyawan);
                                    Navigator.pop(context, "result");
                                      final snackBar = SnackBar(
                                        content: const Text('Movie Disimpan!!'),
                                        backgroundColor: (Colors.black),
                                        action: SnackBarAction(
                                          label: 'Oke',
                                          onPressed: () {
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                              border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 0.1))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            width: 100,
                                            height: 60,
                                            child: Image.network('https://www.themoviedb.org/t/p/w220_and_h330_face/'+movieDetail!.backdropPath.toString(), fit: BoxFit.fitWidth,)
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                                width: 120,
                                                child: Text(
                                                  movieVideoApi!.results![0].name.toString(),
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.star_outlined, color: Colors.amber,),
                                                  Text(movieDetail!.popularity.toString(), style: TextStyle(color: Colors.amber),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: MaterialButton(
                                    color: Colors.blue,
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          "https://www.youtube.com/watch?v="+movieVideoApi!.results![0].key.toString()
                                      ));
                                    },
                                    child: Text('Play', style: TextStyle(color: Colors.white),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 7),
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
                          ),
                        ),
                        Container(
                          child: SizedBox(
                              height: 200,
                              child: isloaded ? ListView.builder(
                                itemCount: 7,
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
                                            child: FadeInImage.assetNetwork(placeholder: 'assets/Eclipse-Loading.gif', width: 140,placeholderCacheWidth: 50, image: 'https://www.themoviedb.org/t/p/w220_and_h330_face/'+moviePopuler!.results![index].posterPath.toString(), fit: BoxFit.fill,),
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
              )
            ]
        ): Center(child: Image.asset('assets/Eclipse-Loading.gif'))
      ),
    );
  }
}
