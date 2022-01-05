import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';

enum BannerAdSize {
  banner,
  mrec,
  leader,
}

class BannerPx {
  final double width;
  final double height;
  BannerPx(this.width, this.height);
}

class BannerAdView extends StatelessWidget {
  final Map<BannerAdSize, String> sizes = {
    BannerAdSize.banner: 'BANNER',
    BannerAdSize.leader: 'LEADER',
    BannerAdSize.mrec: 'MREC'
  };
  final Map<BannerAdSize, BannerPx> sizesNum = {
    BannerAdSize.banner:  BannerPx(350, 50),
    BannerAdSize.leader: BannerPx(double.infinity, 90),
    BannerAdSize.mrec: BannerPx(300, 250)
  };
  final BannerAdSize size;

  BannerAdView(this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("banner_ad_view");
    Map<String, String> creationParams = {};
    if (Platform.isAndroid) {
      creationParams['unitId'] = "MAX Andriod banner Ad UnitID";
    } else {
      creationParams['unitId'] = "MAX iOS banner Ad UnitID";
    }

    creationParams['Size'] = sizes[size].toString();
    if (Platform.isAndroid) {

      final AndroidView androidView = AndroidView(
          viewType: 'flutter_ads_applovin_max/Banner',
          key: UniqueKey(),
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int i) {
          });
      return Container(
          color: Colors.greenAccent,
          width: sizesNum[size]?.width,
          height: sizesNum[size]?.height,
          child: androidView);
    } else {
      final UiKitView iosView = UiKitView(
          viewType: 'flutter_ads_applovin_max/Banner',
          key: UniqueKey(),
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int i) {
          });
      return Container(
          color: Colors.greenAccent,
          width: sizesNum[size]?.width,
          height: sizesNum[size]?.height,
          child: iosView);
    }
  }
}