import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

import 'onboarding_view_model.dart';

class Onboarding extends StatefulWidget {
  @override
  OnboardingView createState() => OnboardingView();
}

class OnboardingView extends State<Onboarding> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            "Covid-19 Takip",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: SizedBox(
            height: 500,
            child: PageView(
              controller: model.pageController,
              onPageChanged: model.handleSlideChange,
              children: model.getSlides(),
            ),
          ),
        ),
        bottomSheet: model.slideIndex != 2
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        model.pageController.animateToPage(2,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear);
                      },
                      splashColor: Colors.blue[50],
                      child: Text(
                        "GEÇ",
                        style: TextStyle(
                            color: Colors.blueAccent[200],
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            PageIndicator(pageIndex: i)
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        model.pageController.animateToPage(model.slideIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      splashColor: Colors.blue[50],
                      child: Text(
                        "İLERİ",
                        style: TextStyle(
                            color: Colors.blueAccent[200],
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () => {
                  model.setOnboardingStepFinish(context),
                  savePrefs(),
                },
                child: Container(
                  height: Platform.isIOS ? 80 : 60,
                  color: Colors.blueAccent[200],
                  alignment: Alignment.center,
                  child: Text(
                    "HAYDİ BAŞLAYALIM",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
              ),
      ),
      viewModelBuilder: () => OnboardingViewModel(),
    );
  }

  Future<void> savePrefs() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('onboarding', "ok");
  }
}

class PageIndicator extends ViewModelWidget<OnboardingViewModel> {
  final pageIndex;
  PageIndicator({Key key, this.pageIndex}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: model.isCurrentSlide(pageIndex) ? 10.0 : 6.0,
      width: model.isCurrentSlide(pageIndex) ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: model.isCurrentSlide(pageIndex) ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
