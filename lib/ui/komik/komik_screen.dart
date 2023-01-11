import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/komik/komik_detail.dart';
import 'package:mobile_pssi/ui/login/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class KomikScreen extends StatefulWidget {
  static const routeName = '/komik';
  const KomikScreen({Key? key}) : super(key: key);

  @override
  State<KomikScreen> createState() => _KomikScreenState();
}

class _KomikScreenState extends State<KomikScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Komik'.text.make(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 28, right: 28, top: 10),
                height: 230,
                child: Stack(
                  children: [
                    Positioned(
                        child: Material(
                      child: Container(
                        height: 240.96,
                        width: 335.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Banyak komik yang menarik untuk dibaca',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  debugPrint('View Button');
                                },
                                child: Text(
                                  'View',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1517466787929-bc90951d0974?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHx8&w=1000&q=80',
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: NetworkImage(
                                  'https://st3.depositphotos.com/1642684/32403/v/450/depositphotos_324033806-stock-illustration-little-children-playing-football-outdoor.jpg'),
                              fit: BoxFit.fitHeight,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.7),
                                  BlendMode.dstATop),
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                "Genre",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  InkWell(
                    onTap: _toKomikDetail,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 135.0,
                            width: 98.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 1",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTx891_ZPTJlQdHFFaiTSpFgEQlogqPRmY4qaf3n9IEuy5ae3xe30cgwp-BzdLhUZbhztY&usqp=CAU'),
                                  fit: BoxFit.fitHeight,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint('Card Komik 2');
                    },
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 135.0,
                            width: 98.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 2",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://png.pngtree.com/element_our/20190522/ourlarge/pngtree-cartoon-football-player-picture-image_1068525.jpg'),
                                  fit: BoxFit.fitHeight,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      debugPrint('Card Komik 3');
                    },
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 135.0,
                            width: 98.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 3",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://img.freepik.com/free-vector/cartoon-football-players-set_23-2149040499.jpg?w=2000'),
                                  fit: BoxFit.fitHeight,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 135.0,
                            width: 98.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 4",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://i.pinimg.com/originals/58/37/75/583775976b974b88dbbccd20c2f38a0a.jpg'),
                                  fit: BoxFit.fitWidth,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 135.0,
                            width: 98.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 5",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTI9vecCx2rjx5X2lM5gzBdcjYiIZGGepOUwA&usqp=CAU'),
                                  fit: BoxFit.fitWidth,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 135.0,
                            width: 98.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 6",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm07WqDXIfxAf0aSX2mW7i-GVP7e3UHQqpVg&usqp=CAU'),
                                  fit: BoxFit.fitWidth,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                "Popular",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12.0,
              ),
              Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 106.0,
                            width: 146.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 1",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png'),
                                  fit: BoxFit.fitWidth,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Material(
                          child: Container(
                            height: 106.0,
                            width: 146.0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 27,
                                    width: 90,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Latihan 1",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png'),
                                  fit: BoxFit.fitWidth,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
            ],
          ),
        ));
  }
}

_toKomikDetail() {
  Get.toNamed(KomikDetail.routeName);
}
