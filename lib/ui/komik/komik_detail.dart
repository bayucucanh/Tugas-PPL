import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:velocity_x/velocity_x.dart';

class KomikDetail extends StatefulWidget {
  static const routeName = '/komikDetail';
  const KomikDetail({Key? key}) : super(key: key);

  @override
  State<KomikDetail> createState() => _KomikDetailState();
}

class _KomikDetailState extends State<KomikDetail> {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Detail Komik'.text.make(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 250.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: NetworkImage(
                        'https://asset-a.grid.id//crop/0x0:0x0/700x465/photo/2021/09/17/macam-macam-gerak-dasar-permaina-20210917084835.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 349.0,
                      padding: EdgeInsets.all(9.00),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Latihan".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          Text(
                            "Chapter 1",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          Text(
                            "Dribble",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          Text(
                            "dribble adalah menggiring bola dari satu titik ke titik lain di lapangan. Ada beberapa teknik dasar yang bisa kita pelajari agar bisa ...",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xfffff),
                        image: new DecorationImage(
                            image: NetworkImage(
                                'https://1.bp.blogspot.com/-oRSFgCF-MMs/YL7113c3_NI/AAAAAAAAIic/nfoDS2NdvGoNMMTo0yD1bAP3WORIt-eYgCLcBGAsYHQ/s1920/background-hitam-polos.jpg'),
                            fit: BoxFit.fitWidth,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 12.0,
            ),
            Card(
              color: Color(0xD9D9D9),
              child: InkWell(
                onTap: (() {
                  debugPrint('Episode 2');
                }),
                child: Container(
                  padding: EdgeInsets.only(
                      top: 9.0, left: 18, right: 18, bottom: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Episode 2".toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      new Container(
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined),
                            const SizedBox(width: 5),
                            Text(
                              "157.000",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      // const SizedBox(width: 34),
                      Text(
                        "27 November 2017",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      Text(
                        "#2".toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Color(0xD9D9D9),
              child: InkWell(
                onTap: (() {
                  debugPrint('Episode 1');
                }),
                child: Container(
                  padding: EdgeInsets.only(
                      top: 9.0, left: 18, right: 18, bottom: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Episode 1".toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      new Container(
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined),
                            const SizedBox(width: 5),
                            Text(
                              "157.000",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      // const SizedBox(width: 34),
                      Text(
                        "27 November 2017",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      Text(
                        "#1".toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
