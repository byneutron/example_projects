import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:triaj/survey.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  final userKey;

  const Profile({Key key, this.userKey}) : super(key: key);
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  var data;
  String id = "", email = "", name = "", date = "";
  Future<void> save() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http
            .post("http://triaj.telesetgroup.com/api_verification.php", body: {
          "flag": 5.toString(),
          "idno": widget.userKey.toString(),
          "fcm_token": "test_fcm_token",
        });
        data = jsonDecode(response.body);
        int value = data['value'];

        if (value == 1) {
          setState(() {
            idn = data['id'].toString();
            email = data['email'].toString();
            name = data['name'].toString();
            date = data['date'].toString();
          });
        } else {
          updateToast("VERİ OKUMAMADI!");
        }
      }
    } on SocketException catch (_) {
      print("İnternet Bağlantısı Yok");
      notConToast("İNTERNET BAĞLANTISI YOK!");
    }
  }

  notConToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  updateToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  @override
  void initState() {
    save();
    super.initState();
  }

  Widget _backBtn() {
    return Container(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 50,
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {
            setState(
              () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurveyApp(
                      surveyID: widget.userKey.toString(),
                    ),
                  ),
                );
              },
            ),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF7986CB),
                      Color(0xFF5C6BC0),
                      Color(0xFF3F51B5),
                      Color(0xFF3949AB),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    image: AssetImage('assets/images/back.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 30.0,
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _backBtn(),
                          Text(
                            'TELESET SAĞLIK FORMU',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'OpenSans',
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'PROFİL SAYFASI',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'OpenSans',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Icon(
                            Icons.person,
                            size: 130,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "SİCİL : ",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      idnom,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "İSİM : ",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      namem,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "EMAİL: ",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      emailm,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      "KAYIT TARİHİ : ",
                                      style: TextStyle(fontSize: 20),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    datem,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
