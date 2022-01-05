#import "FlutterAdsApplovinMaxPlugin.h"
#import "InterstitialAd.h"
#import <objc/runtime.h>

@implementation InterstitialAd {
  MAInterstitialAd* interAd;
  int retryAttempt;
}

- (void)initialize:(NSString*)unitId {
  interAd = [[MAInterstitialAd alloc] initWithAdUnitIdentifier: unitId];
  interAd.delegate = self;

  // Load the first ad
  [interAd loadAd];
}

- (BOOL)isLoaded {
  return [interAd isReady];
}

- (void)show {
  if ( [interAd isReady] )
  {
      [interAd showAd];
  }
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    // Rewarded ad is ready to be shown. '[self.rewardedAd isReady]' will now return 'YES'

    // Reset retry attempt
    retryAttempt = 0;
    [globalChannel invokeMethod:@"onInterstitialAdLoaded" arguments:nil];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    // Rewarded ad failed to load
    // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)

    retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, retryAttempt));

[globalChannel invokeMethod:@"onInterstitalAdLoadFailed" arguments:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [interAd loadAd];
    });
}

- (void)didDisplayAd:(MAAd *)ad {
[globalChannel invokeMethod:@"onInterstitialAdDisplayed" arguments:nil];
}

- (void)didClickAd:(MAAd *)ad {
[globalChannel invokeMethod:@"onInterstitalAdClicked" arguments:nil];
}

- (void)didHideAd:(MAAd *)ad
{
[globalChannel invokeMethod:@"onInterstitialAdHidden" arguments:nil];
    // Rewarded ad is hidden. Pre-load the next ad
    [interAd loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    // Rewarded ad failed to display. We recommend loading the next ad

    [globalChannel invokeMethod:@"onInterstitialAdDisplayFailed" arguments:nil];
    [interAd loadAd];
}

@end
