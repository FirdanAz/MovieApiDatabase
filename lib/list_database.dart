import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tv_movie/Database/movie_database.dart';
import 'package:tv_movie/DetailPage.dart';
import 'package:tv_movie/theme.dart';

import 'Database/database_model.dart';

class ListMoviePage extends StatefulWidget {
  const ListMoviePage({Key? key}) : super(key: key);

  @override
  State<ListMoviePage> createState() => _ListMoviePageState();
}

class _ListMoviePageState extends State<ListMoviePage> {
  List<MovieModel> dataListMovie = [];
  bool isLoading = false;

  Future read() async {
    setState(() {
      isLoading = true;
    });
    dataListMovie = await MovieDatabase.instance.readAll();
    print("Length List " + dataListMovie.length.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  showDeleteDialog(BuildContext context, int? id) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Hapus"),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        await MovieDatabase.instance.delete(id);
        read();
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin menghapus?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorr.darkColor,
      appBar: AppBar(
        backgroundColor: Colorr.darkColor,
        title: Text(
          'Favorite',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body:
      isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : dataListMovie.length == 0 ? Center(child: Text("no data available"),) :
      ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: dataListMovie.length,
        itemBuilder: (c, index) {
          final item = dataListMovie[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(color: Colors.grey, width: 0.1))
              ),
              child: Card(
                color: Colorr.darkColor,
                child: ListTile(
                  onTap: () async{
                    int id = int.parse(item.idMovie);
                    print(id);
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DetailPage(id: id)));
                    Future.delayed(Duration(seconds: 2));
                    read();
                  },
                  leading: Container(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      (item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item.name, style: TextStyle(fontSize: 16, color: Colors.white),),
                  subtitle: Text('ID : ${item.idMovie}', style: TextStyle(color: Colors.white70),),
                  trailing: IconButton(
                    onPressed: () {
                      showDeleteDialog(context, item.id);
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
