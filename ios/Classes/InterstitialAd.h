#import <Flutter/Flutter.h>
#import <AppLovinSDK/AppLovinSDK.h>

@interface InterstitialAd : NSObject<MAAdDelegate>
- (void)initialize:(NSString*)unitId;
- (BOOL)isLoaded;
- (void)show;
@end
