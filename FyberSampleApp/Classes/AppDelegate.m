//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "AppDelegate.h"
#import "FyberSDK.h"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Start the SDK with the appId and a security token that you can find in
    // the Fyber Dashboard http://dashboard.fyber.com
    
    [FyberSDK startWithAppId:@"22912" securityToken:@"token"];
    
    return YES;
}

@end
