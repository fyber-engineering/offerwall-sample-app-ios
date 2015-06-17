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
