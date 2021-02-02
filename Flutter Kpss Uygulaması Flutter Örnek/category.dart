import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:kpss/quiz/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kpss/screens/notcon_screen.dart';
import 'package:kpss/screens/pdf_view_screen.dart';
import 'package:kpss/screens/web_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpss/utilities/admob_services.dart';

class CategoryJson extends StatefulWidget {
  final link;
  final title;
  final image;
  const CategoryJson({Key key, this.link, this.title, this.image})
      : super(key: key);
  @override
  StateCategoryJson createState() => StateCategoryJson();
}

class StateCategoryJson extends State<CategoryJson> {
  final AdvertService advertService = new AdvertService();
  Color c = const Color(0xFF323D4F);
  String connectJson = "Sayfa Yükleniyor...";
  bool _connection;
  bool adsnull = false;
  bool trailingCheck = false;
  var jsonData;
  Future<List<Category>> _getCategories() async {
    List<Category> categories = [];
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = await http.get(widget.link);
        if (data.statusCode == 200) {
          jsonData = json.decode(utf8.decode(data.bodyBytes));

          for (var c in jsonData) {
            Category category =
                Category(c["index"], c["name"], c["link"], c["cat"]);

            categories.add(category);
          }
        }
      }
    } on SocketException catch (_) {
      connectJson = "İnternet Bağlantınız Bulunmamaktadır!";
    }
    return categories;
  }

  Set<String> favs = Set<String>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  initState() {
    super.initState();
    if (favs.isEmpty) {
      SharedPreferences.getInstance().then((prefs) {
        if (prefs.getStringList("favs") != null) {
          favs.addAll(prefs.getStringList("favs"));
        }
        setState(() {});
      });
      if (widget.title == "Tarih Sınavı" ||
          widget.title == "Türkçe Sınavı" ||
          widget.title == "Cografya Sınavı" ||
          widget.title == "SINAVLAR" ||
          widget.image == "images/exam.png") {
        trailingCheck = false;
      } else {
        trailingCheck = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c,
      appBar: AppBar(
        backgroundColor: c,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text(
                  connectJson,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else if (connectJson == "İnternet Bağlantınız Bulunmamaktadır!") {
            return Container(
              child: Center(
                child: NotCon(
                  title: "none",
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                String meal = snapshot.data[index].name;
                String links = snapshot.data[index].link;
                return Card(
                  color: Colors.blueGrey,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        new Container(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(widget.image),
                            ),
                            title: Text(
                              snapshot.data[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              if (widget.title == "Türkçe Konu Anlatımı") {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => MyWebView(
                                              title: snapshot.data[index].name,
                                              selectedUrl:
                                                  snapshot.data[index].link,
                                            )));
                              } else if (widget.title == "SINAVLAR" ||
                                  snapshot.data[index].cat == "list") {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => CategoryJson(
                                              title: snapshot.data[index].name,
                                              link: snapshot.data[index].link,
                                              image: "images/exam.png",
                                            )));
                              } else if (snapshot.data[index].cat == "sinav") {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      GetJson(langname: links),
                                ));
                              } else {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => PdfViewScreen(
                                              title: snapshot.data[index].name,
                                              link: snapshot.data[index].link,
                                            )));
                              }
                            },
                            trailing: Visibility(
                              visible: trailingCheck,
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    child: IconButton(
                                      icon: new Icon(
                                          isFavorite(meal)
                                              ? Icons.remove_circle
                                              : Icons.add_circle,
                                          color: isFavorite(meal)
                                              ? Colors.pink[300]
                                              : Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          addRemFavorite(meal);
                                        });
                                      },
                                      iconSize: 35,
                                    ),
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
              },
            );
          }
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Visibility(
      //     visible: adsnull,
      //     child: SizedBox(
      //       height: 50,
      //       child: AdmobBanner(
      //         adUnitId: getBannerAdUnitId(),
      //         adSize: bannerSize,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  bool isFavorite(String meal) {
    return favs.contains(meal);
  }

  void addRemFavorite(String meal) async {
    if (favs.contains(meal)) {
      favs.remove(meal);
      messageRemove(context);
    } else {
      favs.add(meal);
      messageAdd(context);
    }
    savePrefs(favs);
  }

  void savePrefs(Set<String> favs) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setStringList('favs', favs.toList());
  }

  void messageAdd(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Favorilere Eklendi.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void messageRemove(BuildContext context) {
    Fluttertoast.showToast(
        msg: "Favorilerden Çıkarıldı.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _connection = true;
      }
    } on SocketException catch (_) {
      _connection = false;
    }
    if (_connection == true) {
      adsnull = true;
    } else {
      adsnull = false;
    }
  }
}

class Category {
  final int index;
  final String name;
  final String link;
  final String cat;
  Category(this.index, this.name, this.link, this.cat);
}