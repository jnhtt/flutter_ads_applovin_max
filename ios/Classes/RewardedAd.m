#import "FlutterAdsApplovinMaxPlugin.h"
#import "RewardedAd.h"
#import <objc/runtime.h>

@implementation RewardedAd {
  MARewardedAd* rewarded;
  int retryAttempt;
}

- (void)initialize:(NSString*)unitId {
  rewarded = [MARewardedAd sharedWithAdUnitIdentifier: unitId];
  rewarded.delegate = self;

  // Load the first ad
  [rewarded loadAd];
}

- (BOOL)isLoaded {
  return [rewarded isReady];
}

- (void)show {
  if ( [rewarded isReady] )
  {
      [rewarded showAd];
  }
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad
{
    // Rewarded ad is ready to be shown. '[self.rewardedAd isReady]' will now return 'YES'

    // Reset retry attempt
    retryAttempt = 0;
    [globalChannel invokeMethod:@"onRewardedAdLoaded" arguments:nil];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error
{
    // Rewarded ad failed to load
    // We recommend retrying with exponentially higher delays up to a maximum delay (in this case 64 seconds)

    retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, retryAttempt));

[globalChannel invokeMethod:@"onRewardedAdLoadFailed" arguments:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self->rewarded loadAd];
    });
}

- (void)didDisplayAd:(MAAd *)ad {
[globalChannel invokeMethod:@"onRewardedAdDisplayed" arguments:nil];
}

- (void)didClickAd:(MAAd *)ad {
[globalChannel invokeMethod:@"onRewardedAdClicked" arguments:nil];
}

- (void)didHideAd:(MAAd *)ad
{
[globalChannel invokeMethod:@"onRewardedAdHidden" arguments:nil];
    // Rewarded ad is hidden. Pre-load the next ad
    [rewarded loadAd];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error
{
    // Rewarded ad failed to display. We recommend loading the next ad

    [globalChannel invokeMethod:@"onRewardedAdDisplayFailed" arguments:nil];
    [rewarded loadAd];
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {
[globalChannel invokeMethod:@"onRewardedAdStarted" arguments:nil];
}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {
[globalChannel invokeMethod:@"onRewardedAdCompleted" arguments:nil];
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward
{
    // Rewarded ad was displayed and user should receive the reward
    retryAttempt = 0;
    [globalChannel invokeMethod:@"onUserRewarded" arguments:nil];
}

@end
