//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "FyberSDK.h"
#import "UIFont+FYBFont.h"
#import "UIColor+FYBColor.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the log level of the FyberSDK
    [FyberSDK setLoggingLevel:FYBLogLevelDebug];
    
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
            NSForegroundColorAttributeName: [UIColor fyb_textColor],
            NSFontAttributeName: [UIFont fyb_navigationBarFont]
    };

    [UINavigationBar appearance].titleTextAttributes = navBarTitleTextAttributes;
    [UINavigationBar appearance].barTintColor = [UIColor fyb_brownColor];
}

@end
