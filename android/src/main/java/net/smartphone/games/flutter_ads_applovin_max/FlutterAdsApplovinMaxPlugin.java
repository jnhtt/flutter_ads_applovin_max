package net.smartphone.games.flutter_ads_applovin_max;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.lang.Object;
import java.util.Hashtable;
import java.util.Timer;
import java.util.TimerTask;

import com.applovin.sdk.AppLovinMediationProvider;
import com.applovin.sdk.AppLovinSdk;
import com.applovin.sdk.AppLovinSdkConfiguration;
import com.applovin.sdk.AppLovinPrivacySettings;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMethodCodec;
import io.flutter.plugin.platform.PlatformViewRegistry;

/** FlutterAdsApplovinMaxPlugin */
public class FlutterAdsApplovinMaxPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {

  private static FlutterAdsApplovinMaxPlugin instance;
  private static Context context;
  private static MethodChannel channel;
  public static Activity activity;

  private static RewardedAd reward;
  private static InterstitialAd interstitial;

  public static FlutterAdsApplovinMaxPlugin getInstance() {
    return instance;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.onAttachedToEngine(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
    flutterPluginBinding.getPlatformViewRegistry()
            .registerViewFactory("flutter_ads_applovin_max/Banner", new NativeViewFactory(flutterPluginBinding.getBinaryMessenger()));
  }

  public static void registerWith(Registrar registrar) {
    if (instance == null) {
      instance = new FlutterAdsApplovinMaxPlugin();
    }
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  public void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    if (channel != null) {
      return;
    }

    instance = new FlutterAdsApplovinMaxPlugin();
    this.context = applicationContext;
    channel = new MethodChannel(messenger, "flutter_ads_applovin_max", StandardMethodCodec.INSTANCE);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    try {
      switch (call.method) {
        case "initializeSdk":
          AppLovinSdk.getInstance(activity).setMediationProvider(AppLovinMediationProvider.MAX);
          AppLovinSdk.initializeSdk(activity, new AppLovinSdk.SdkInitializationListener() {
            @Override
            public void onSdkInitialized(final AppLovinSdkConfiguration configuration) {
              sendToFlutter("finishInitializeSdk");
            }
          });
          break;
        case "setHasUserConsent":
          final boolean userConsent = call.argument("userConsent");
          AppLovinPrivacySettings.setHasUserConsent( userConsent, context );
          break;
        case "setIsAgeRestrictedUser":
          final boolean isAgeRestrictedUser = call.argument("isAgeRestrictedUser");
          AppLovinPrivacySettings.setIsAgeRestrictedUser( isAgeRestrictedUser, context );
          break;
        case "setDoNotSell":
          final boolean doNotSell = call.argument("doNotSell");
          AppLovinPrivacySettings.setDoNotSell( doNotSell, context );
          break;
        case "initializeRewardedAd":
          String unitId = call.argument("unitId").toString();
          reward.initialize(unitId);
          result.success(true);
          break;
        case "showRewardedAd":
          reward.show();
          result.success(true);
          break;
        case "isLoadedRewardedAd":
          boolean isLoaded = reward.isLoaded();
          result.success(isLoaded);
          break;
        case "initializeInterstitialAd":
          unitId = call.argument("unitId").toString();
          interstitial.initialize(unitId);
          result.success(true);
          break;
        case "showInterstitialAd":
          interstitial.show();
          result.success(true);
          break;
        case "isLoadedInterstitialAd":
          isLoaded = interstitial.isLoaded();
          result.success(isLoaded);
          break;
      }
    }
    catch (Exception e) {
      Log.e("Method error ", e.toString());
      result.notImplemented();
    }
  }

  static public void sendToFlutter(final String method) {
    if (instance.context != null && instance.channel != null && instance.activity != null) {
      instance.activity.runOnUiThread(new Runnable() {
        @Override
        public void run() {
          instance.channel.invokeMethod(method, null);
        }
      });
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    this.context = null;
    this.channel.setMethodCallHandler(null);
    this.channel = null;
    Log.i("FlutterAdsApplovinMaxPlugin", "onDetachedFromEngine");
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    Log.i("FlutterAdsApplovinMaxPlugin", "onAttachedToActivity");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    Log.i("FlutterAdsApplovinMaxPlugin", "onDetachedFromActivityForConfigChanges");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    instance.reward = new RewardedAd();
    Log.i("FlutterAdsApplovinMaxPlugin", "onReattachedToActivityForConfigChanges");
  }

  @Override
  public void onDetachedFromActivity() {
    Log.i("FlutterAdsApplovinMaxPlugin", "onDetachedFromActivity");
  }
}
