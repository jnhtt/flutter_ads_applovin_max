package net.smartphone.games.flutter_ads_applovin_max;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxAdRevenueListener;
import com.applovin.mediation.MaxError;
import com.applovin.mediation.MaxReward;
import com.applovin.mediation.MaxRewardedAdListener;
import com.applovin.mediation.ads.MaxRewardedAd;

import io.flutter.Log;

public class RewardedAd implements MaxRewardedAdListener, MaxAdRevenueListener {
    private MaxRewardedAd reward;
    private int retryAttempt;

    public void initialize(String unitId) {
        reward = MaxRewardedAd.getInstance(unitId, FlutterAdsApplovinMaxPlugin.getInstance().activity );
        reward.setListener( this );
        reward.loadAd();
    }

    public void show() {
        try {
            if (reward != null && reward.isReady() && FlutterAdsApplovinMaxPlugin.getInstance().activity != null)
                reward.showAd();
        } catch (Exception e) {
            Log.e("AppLovin", e.toString());
        }
    }

    public boolean isLoaded() {
        return reward.isReady();
    }

    @Override
    public void onAdLoaded(MaxAd ad) {
        retryAttempt = 0;
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdLoaded");

    }

    @Override
    public void onAdDisplayed(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdDisplayed");

    }

    @Override
    public void onAdHidden(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdHidden");
        reward.loadAd();
    }

    @Override
    public void onAdClicked(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdClicked");
    }

    @Override
    public void onAdLoadFailed(String adUnitId, MaxError error) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdLoadFailed");
    }

    @Override
    public void onAdDisplayFailed(MaxAd ad, MaxError error) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdDisplayFailed");
    }

    @Override
    public void onRewardedVideoStarted(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdStarted");

    }

    @Override
    public void onRewardedVideoCompleted(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdCompleted");

    }

    @Override
    public void onAdRevenuePaid(MaxAd ad) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onRewardedAdRevenuePaid");
    }

    @Override
    public void onUserRewarded(MaxAd ad, MaxReward reward) {
        FlutterAdsApplovinMaxPlugin.getInstance().sendToFlutter("onUserRewarded");
    }
}