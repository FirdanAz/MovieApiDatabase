import 'package:flutter/material.dart';
import 'package:tv_movie/theme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Colorr.darkColor,
      ),
    );
  }
}
