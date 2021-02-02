import 'dart:async';
import 'dart:math';
import 'package:covid/helpers/style.dart';
import 'package:covid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  final userKey;

  const HomePage({Key key, this.userKey}) : super(key: key);
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  Set<String> names = {};
  Set<String> closestNames = {};
  bool scanning = false;
  final clearFocus = FocusNode();
  Timer t;
  Duration timerX;
  String userKey;
  @override
  void initState() {
    super.initState();
    timerControl();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/launcher_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        assert(payload != null);
      },
    );
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    clearFocus?.dispose();
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Covid-19 Takip",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: "Hoşgeldiniz",
                  size: 24,
                  weight: FontWeight.w500,
                  color: primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "images/plp.png",
                    width: 200,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sosyal mesafeyi aştığınız kişi sayısı',
                  style: TextStyle(
                    color: primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: "${names.length}",
                  size: 25,
                  weight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 5,
                width: MediaQuery.of(context).size.width,
                color: Colors.blueAccent[100],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: "Riskli temas kurduğunuz kişi sayısı",
                  size: 20,
                  weight: FontWeight.w400,
                  color: Colors.redAccent[200],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(
                  text: "${closestNames.length}",
                  size: 25,
                  weight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.high, priority: Priority.max);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Covid-19 Takip',
        'Yakın temasta bulundun! ${names.length + closestNames.length} kişi ile sosyal mesafe kurallarını ihlal ettin!',
        platformChannelSpecifics);
  }

  Future<void> timerControl() async {
    try {
      timerX = const Duration(seconds: 5);
      new Timer.periodic(timerX, (t) => startBroadcast());
    } catch (e) {
      print(e);
    }
  }

  Future<void> startBroadcast() async {
    try {
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      setState(() {
        scanning = true;
      });
      flutterBlue.scanResults.listen(
        (results) {
          double dist = 0;
          for (ScanResult r in results) {
            print(names.toList());
            dist = pow(10, ((-69 - (r.rssi)) / (10 * 2)));
            if (dist < 0.7 && dist > 0.3) {
              if (!names.contains(r.device.id.toString())) {
                setState(() {
                  names.add(r.device.id.toString());
                  _showNotificationWithSound();
                });
              } else {
                print("BURDAYIM");
              }
            } else if (dist < 0.3) {
              if (!closestNames.contains(r.device.id.toString())) {
                setState(() {
                  closestNames.add(r.device.id.toString());
                  _showNotificationWithSound();
                });
              }
            }
          }
        },
      );
      flutterBlue.stopScan();
      setState(() {
        debugPrint("stopped");
        scanning = false;
      });
    } on PlatformException catch (err) {
      // Handle err
      print(err);
    } catch (err) {
      // other types of Exceptions
    }
  }
}
