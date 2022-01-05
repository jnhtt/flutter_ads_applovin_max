import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ads_applovin_max/flutter_ads_applovin_max.dart';
import 'package:flutter_ads_applovin_max/banner_ad_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialized = 'not initialize';

  @override
  void initState() {
    super.initState();
    FlutterAdsApplovinMax.init();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    await FlutterAdsApplovinMax.initializeSdk(() {
      _initialized = "initialized";
      _initializeAds();
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
    });
  }

  Future<void> _initializeAds() async {
    FlutterAdsApplovinMax.initializeRewardedAd();
    FlutterAdsApplovinMax.initializeInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: _buildButtonList(context),
        ),
      ),
    );
  }

  Widget _buildButtonList(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text('MAX: $_initialized\n'),
        _createButton("Show RewardedAd", () {
          FlutterAdsApplovinMax.showRewardedAd(
                  () { print("----------- success"); },
                  () {print("-------------- failed");});
        }),
        SizedBox(height: 10,),
        _createButton("Show InterstitialAd", () {
          FlutterAdsApplovinMax.showIniterstitialAd(
                  () { print("----------- success"); });
        }),
        SizedBox(height: 10,),
        BannerAdView(BannerAdSize.banner),
      ],
    );
  }

  Widget _createButton(String text, VoidCallback cb) {
    return GestureDetector(
        onTap: cb,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent,
          ),
          child: Text(text, style: TextStyle(color: Colors.white),),
        ));
  }
}