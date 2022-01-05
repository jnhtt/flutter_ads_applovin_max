#import "FlutterAdsApplovinMaxPlugin.h"

#import <objc/runtime.h>
#import <AppLovinSDK/AppLovinSDK.h>

#import "RewardedAd.h"
#import "InterstitialAd.h"

#import "FLNativeView.h"

FlutterMethodChannel* globalChannel = nil;

@implementation FlutterAdsApplovinMaxPlugin {
  RewardedAd* reward;
  InterstitialAd* interstitial;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  globalChannel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_ads_applovin_max"
            binaryMessenger:[registrar messenger]];
  FlutterAdsApplovinMaxPlugin* instance = [[FlutterAdsApplovinMaxPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:globalChannel];

  BannerAdViewFactory* factory =
        [[BannerAdViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"flutter_ads_applovin_max/Banner"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initializeSdk" isEqualToString:call.method]) {
    [ALSdk shared].mediationProvider = ALMediationProviderMAX;
    [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {
            // AppLovin SDK is initialized, start loading ads now or later if ad gate is reached
            [self sendToFlutter:@"finishInitializeSdk"];
        }];
    result(@"start initializeSdk");
  } else if ([@"setHasUserConsent" isEqualToString:call.method]) {
    BOOL userConsent = call.arguments[@"userConsent"];
    [ALPrivacySettings setHasUserConsent: userConsent];
  } else if ([@"setIsAgeRestrictedUser" isEqualToString:call.method]) {
    BOOL isAgeRestrictedUser = call.arguments[@"isAgeRestrictedUser"];
    [ALPrivacySettings setIsAgeRestrictedUser: isAgeRestrictedUser];
  } else if ([@"setDoNotSell" isEqualToString:call.method]) {
    BOOL doNotSell = call.arguments[@"doNotSell"];
    [ALPrivacySettings setDoNotSell: doNotSell];
  } else if ([@"initializeRewardedAd" isEqualToString:call.method]) {
    NSString* unitId = call.arguments[@"unitId"];
    reward = [[RewardedAd alloc] init];
    [reward initialize :unitId];
  } else if ([@"showRewardedAd" isEqualToString:call.method]) {
    [reward show];
  } else if ([@"isLoadedRewardedAd" isEqualToString:call.method]) {
    [reward isLoaded];
  } else if ([@"initializeInterstitialAd" isEqualToString:call.method]) {
    NSString* unitId = call.arguments[@"unitId"];
    interstitial = [[InterstitialAd alloc] init];
    [interstitial initialize :unitId];
  } else if ([@"showInterstitialAd" isEqualToString:call.method]) {
    [interstitial show];
  } else if ([@"isLoadedInterstitialAd" isEqualToString:call.method]) {
    [interstitial isLoaded];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)sendToFlutter:(NSString*)method {
    [globalChannel invokeMethod:method arguments:nil];
}


@end
