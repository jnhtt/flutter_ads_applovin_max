#import "BannerAdView.h"

@implementation FLNativeViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[BannerAdView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation BannerAdView {
   UIView *_view;
   MAAdView *adView;
   FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
    _view = [[UIView alloc] init];
    [self initialize :args["unitId"];
  }
  return self;
}

- (UIView*)view {
  return _view;
}

- (void)initialize:(NSString*)unitId {
  adView = [[MAAdView alloc] initWithAdUnitIdentifier: unitId];
  adView.delegate = self;

  // Banner height on iPhone and iPad is 50 and 90, respectively
  CGFloat height = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 90 : 50;

  // Stretch to the width of the screen for banners to be fully functional
  CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds);

  // TODO
  adView.frame = CGRectMake(-width * 0.5, 0, width, height);

  // Set background or background color for banners to be fully functional
  adView.backgroundColor = [UIColor clearColor];

  [_view addSubview: adView];

  // Load the ad
  [adView loadAd];
}

- (void)show {
  adView.hidden = NO;
  [adView startAutoRefresh];
}
- (void)hide {
  adView.hidden = YES;
  [adView stopAutoRefresh];
}

- (UIView*)view {
  return _view;
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}


#pragma mark - MAAdViewAdDelegate Protocol

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

#pragma mark - Deprecated Callbacks

- (void)didDisplayAd:(MAAd *)ad { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
- (void)didHideAd:(MAAd *)ad { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

@end
