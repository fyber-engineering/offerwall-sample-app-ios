//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "AppDelegate.h"
#import "FyberSDK.h"
#import "UIFont+FYBFont.h"
#import "UIColor+FYBColor.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Start the SDK with the appId and a security token that you can find in
    // the Fyber Dashboard http://dashboard.fyber.com
    FYBSDKOptions *options = [FYBSDKOptions optionsWithAppId:@"22912" securityToken:@"token"];
    [FyberSDK startWithOptions:options];
    

    [self customizeAppearance];
    
    return YES;
}

#pragma mark - Private

- (void)customizeAppearance
{
    NSDictionary *navBarTitleTextAttributes = @{
            NSForegroundColorAttributeName : [UIColor fyb_textColor],
            NSFontAttributeName : [UIFont fyb_navigationBarFont]
    };


    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
}

@end
