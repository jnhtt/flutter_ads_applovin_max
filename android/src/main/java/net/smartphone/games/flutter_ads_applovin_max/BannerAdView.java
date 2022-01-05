package net.smartphone.games.flutter_ads_applovin_max;

import android.app.Activity;
import android.content.Context;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.graphics.Color;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import com.applovin.adview.AppLovinAdView;
import com.applovin.adview.AppLovinAdViewDisplayErrorCode;
import com.applovin.adview.AppLovinAdViewEventListener;

import com.applovin.mediation.MaxAd;
import com.applovin.mediation.MaxReward;
import com.applovin.mediation.MaxAdViewAdListener;
import com.applovin.mediation.MaxError;

import com.applovin.mediation.ads.MaxAdView;
import com.applovin.sdk.AppLovinAd;
import com.applovin.sdk.AppLovinAdClickListener;
import com.applovin.sdk.AppLovinAdDisplayListener;
import com.applovin.sdk.AppLovinAdLoadListener;
import com.applovin.sdk.AppLovinAdSize;
import com.applovin.sdk.AppLovinSdkUtils;
import java.util.HashMap;
import java.util.Map;
import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.platform.PlatformView;

class BannerAdView extends FlutterActivity implements PlatformView, MaxAdViewAdListener {
    @NonNull private MaxAdView adView;

    BannerAdView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {

        Activity act = FlutterAdsApplovinMaxPlugin.activity;
        adView = new MaxAdView( creationParams.get("unitId").toString(), act );
        adView.setListener( this );

        // Stretch to the width of the screen for banners to be fully functional
        int width = ViewGroup.LayoutParams.MATCH_PARENT;

        // Banner height on phones and tablets is 50 and 90, respectively
        final boolean isTablet = AppLovinSdkUtils.isTablet( act );
        final int heightPx = AppLovinSdkUtils.dpToPx( act, isTablet ? 90 : 50 );

        adView.setLayoutParams( new FrameLayout.LayoutParams( width, heightPx,  Gravity.CENTER) );

        // Set background or background color for banners to be fully functional
        adView.setBackgroundColor( Color.RED );

        // Load the ad
        adView.loadAd();
    }

    @NonNull
    @Override
    public View getView() {
        return adView;
    }

    @Override
    public void dispose() {}

    // MAX Ad Listener
    @Override
    public void onAdLoaded(final MaxAd maxAd) {
        Log.i("Banner", "Success");
    }

    @Override
    public void onAdLoadFailed(final String adUnitId, final MaxError error) {
        Log.i("Banner", error.toString());
    }

    @Override
    public void onAdDisplayFailed(final MaxAd maxAd, final MaxError error) {}

    @Override
    public void onAdClicked(final MaxAd maxAd) {}

    @Override
    public void onAdExpanded(final MaxAd maxAd) {}

    @Override
    public void onAdCollapsed(final MaxAd maxAd) {}

    @Override
    public void onAdDisplayed(final MaxAd maxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

    @Override
    public void onAdHidden(final MaxAd maxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }
}