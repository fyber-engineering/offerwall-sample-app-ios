//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "UIFont+FYBFont.h"
#import "UIColor+FYBColor.h"
@import FairBidSDK.Swift;
@import FairBidSDK.OfferWall;

@interface AppDelegate() <OFWOfferWallDelegate, OFWVirtualCurrencyDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [OfferWall setLogLevel:OFWLogLevelDebug];

    // Start the SDK with the appId and a security token that you can find in
    // the Fyber Dashboard http://dashboard.fyber.com
    OFWVirtualCurrencyStartOptions *vcsStartOptions = [OFWVirtualCurrencyStartOptions optionsWithSecurityToken:@"sec_135708" delegate:self];
    [OfferWall startWithAppId:@"135708" delegate:self virtualCurrencyStartOptions:vcsStartOptions completion:^(OFWError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to start");
        }
    }];

    [self customizeAppearance];
    return YES;
}

#pragma mark - Private

- (void)customizeAppearance
{
    NSDictionary *navBarTitleTextAttributes = @{
            NSForegroundColorAttributeName: [UIColor fyb_textColor],
            NSFontAttributeName: [UIFont fyb_navigationBarFont]
    };

    [UINavigationBar appearance].titleTextAttributes = navBarTitleTextAttributes;
    [UINavigationBar appearance].barTintColor = [UIColor fyb_brownColor];
}

#pragma mark - OfferWallDelegate
- (void)didDismiss:(NSString * _Nullable)placementId {
}

- (void)didFailToShow:(NSString * _Nullable)placementId error:(OFWError * _Nonnull)error {
}

- (void)didShow:(NSString * _Nullable)placementId {
}

#pragma mark - VirtualCurrencyDelegate
- (void)didFailWithError:(OFWVirtualCurrencyErrorResponse * _Nonnull)error {
}

- (void)didReceiveResponse:(OFWVirtualCurrencyResponse * _Nonnull)response {
}

@end
