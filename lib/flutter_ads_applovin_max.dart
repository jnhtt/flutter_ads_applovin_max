
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterAdsApplovinMax {
  static const MethodChannel _channel = MethodChannel('flutter_ads_applovin_max');
  static VoidCallback? _finishInitializeCallback;

  static String _rewardUnitId = "";
  static String _interUnitId = "";

  //rewarded ad
  static VoidCallback? _rewardSuccess;
  static VoidCallback? _rewardFailure;
  static bool _rewardSuccessFlag = false;

  //interstitial ad
  static VoidCallback? _interstitialFinish;

  static void init() {
    _channel.setMethodCallHandler(_platformCallHandler);

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _rewardUnitId = "AppLovin MAX iOS Rewarded Ad UnitID";
      _interUnitId = "AppLovin MAX iOS Interstitial Ad UnitID";
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      _rewardUnitId = "AppLovin MAX Android Rewarded Ad UnitID";
      _interUnitId = "AppLovin MAX Android Interstitial Ad UnitID";
    }
  }

  static Future<String?> initializeSdk(VoidCallback cb) async {
    _finishInitializeCallback = cb;
    final String? ret = await _channel.invokeMethod('initializeSdk');
    return ret;
  }

  static Future<void> setHasUserConsent(bool userConsent) async {
    await _channel.invokeMethod('setHasUserConsent', <String, dynamic>{
      'userConsent': userConsent,
    });
  }

  static Future<void> setIsAgeRestrictedUser(bool isAgeRestrictedUser) async {
    await _channel.invokeMethod('setIsAgeRestrictedUser', <String, dynamic>{
      'isAgeRestrictedUser': isAgeRestrictedUser,
    });
  }

  static Future<void> setDoNotSell(bool doNotSell) async {
    await _channel.invokeMethod('setDoNotSell', <String, dynamic>{
      'doNotSell': doNotSell,
    });
  }

  static Future<bool?> initializeRewardedAd() async {
    _channel.setMethodCallHandler(_rewardedAdCallHandler);
    return await _channel.invokeMethod('initializeRewardedAd',<String, dynamic>{
      'unitId': _rewardUnitId});
  }

  static Future<bool?> showRewardedAd(VoidCallback onSuccess, VoidCallback onFailure) async {
    _rewardSuccessFlag = false;
    _rewardSuccess = onSuccess;
    _rewardFailure = onFailure;
    _channel.setMethodCallHandler(_rewardedAdCallHandler);
    return await _channel.invokeMethod('showRewardedAd');
  }

  static Future<bool?> isLoadedRewardedAd() async {
    _channel.setMethodCallHandler(_rewardedAdCallHandler);
    return await _channel.invokeMethod('isLoadedRewardedAd');
  }

  static Future<bool?> initializeInterstitialAd() async {
    _channel.setMethodCallHandler(_interstitialAdCallHandler);
    return await _channel.invokeMethod('initializeInterstitialAd', <String, dynamic>{
      'unitId': _interUnitId});
  }

  static Future<bool?> showIniterstitialAd(VoidCallback onFinish) async {
    _interstitialFinish = onFinish;
    _channel.setMethodCallHandler(_interstitialAdCallHandler);
    return await _channel.invokeMethod('showInterstitialAd');
  }

  static Future<bool?> isLoadedInterstitialAd() async {
    _channel.setMethodCallHandler(_interstitialAdCallHandler);
    return await _channel.invokeMethod('isLoadedInterstitialAd', <String, dynamic>{
      'unitId': 0,
    });
  }

  static Future<Null> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'finishInitializeSdk':
        print('finishInitializeSdk');
        if (_finishInitializeCallback != null) {
          _finishInitializeCallback!();
        }
        break;
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  static Future<Null> _rewardedAdCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onRewardedAdLoaded':
        break;
      case 'onRewardedAdDisplayed':
        break;
      case 'onRewardedAdHidden':
        if (_rewardSuccessFlag) {
          _rewardSuccess?.call();
        } else {
          _rewardFailure?.call();
        }
        break;
      case 'onRewardedAdClicked':
        break;
      case 'onRewardedAdLoadFailed':
        break;
      case 'onRewardedAdDisplayFailed':
        break;
      case 'onRewardedAdStarted':
        break;
      case 'onRewardedAdCompleted':
        break;
      case 'onRewardedAdRevenuePaid':
        break;
      case 'onUserRewarded':
        _rewardSuccessFlag = true;
        break;

      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  static Future<Null> _interstitialAdCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onInterstitialAdLoaded':
        break;
      case 'onInterstitialAdDisplayed':
        break;
      case 'onInterstitialAdHidden':
        _interstitialFinish?.call();
        break;
      case 'onInterstitialAdClicked':
        break;
      case 'onInterstitialAdLoadFailed':
        break;
      case 'onInterstitialAdDisplayFailed':
        break;
      case 'onInterstitialAdStarted':
        break;

      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }
}
