//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Start the SDK with the appId and a security token that you can find in
    // the Fyber Dashboard http://dashboard.fyber.com
    
    [FyberSDK startWithAppId:@"22912" securityToken:@"token"];

    [self customizeAppearance];
    
    return YES;
}

#pragma mark - Private

- (void)customizeAppearance
{
    NSDictionary *navBarTitleTextAttributes = @{
            NSForegroundColorAttributeName : [UIColor whiteColor],
            NSFontAttributeName : [UIFont fontWithName:@"Circular-Book" size:20.0]
    };


    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
}

@end
