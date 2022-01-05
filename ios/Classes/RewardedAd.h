#import <Flutter/Flutter.h>
#import <AppLovinSDK/AppLovinSDK.h>

@interface RewardedAd : NSObject<MARewardedAdDelegate>
- (void)initialize:(NSString*)unitId;
- (BOOL)isLoaded;
- (void)show;
@end
