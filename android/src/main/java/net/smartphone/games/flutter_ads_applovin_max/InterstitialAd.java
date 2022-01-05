package net.smartphone.games.flutter_ads_applovin_max;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxError;
import com.applovin.mediation.MaxAdListener;
import com.applovin.mediation.ads.MaxInterstitialAd;

import io.flutter.Log;

public class InterstitialAd implements MaxAdListener {
    private MaxInterstitialAd interstitialAd;
    private int retryAttempt;

    public void initialize(String unitId) {
        interstitialAd = new MaxInterstitialAd(unitId, FlutterAdsApplovinMaxPlugin.getInstance().activity );
        interstitialAd.setListener( this );
        interstitialAd.loadAd();
    }

    public void show() {
        try {
            if (interstitialAd != null && interstitialAd.isReady() && FlutterAdsApplovinMaxPlugin.getInstance().activity != null)
                interstitialAd.showAd();
        } catch (Exception e) {
            Log.e("AppLovin", e.toString());
        }
    }

    public boolean isLoaded() {
        return interstitialAd.isReady();
    }

    @Override
    public void onAdLoaded(MaxAd ad) {
        retryAttempt = 0;
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onInterstitialAdLoaded");

    }

    @Override
    public void onAdDisplayed(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onInterstitialAdDisplayed");

    }

    @Override
    public void onAdHidden(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onInterstitialAdHidden");
        interstitialAd.loadAd();
    }

    @Override
    public void onAdClicked(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onInterstitialAdClicked");
    }

    @Override
    public void onAdLoadFailed(String adUnitId, MaxError error) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onInterstitialAdLoadFailed");
    }

    @Override
    public void onAdDisplayFailed(MaxAd ad, MaxError error) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onInterstitialAdDisplayFailed");
    }
}