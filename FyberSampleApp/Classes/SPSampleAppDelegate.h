//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class SPSampleViewController;

@interface SPSampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *viewController;

@property (nonatomic, strong) NSString *lastCredentialsToken;

- (void)showSDKException:(NSException *)exception;

@end

