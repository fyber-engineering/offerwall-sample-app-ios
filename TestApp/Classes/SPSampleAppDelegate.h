//
//  SPPublishAppDelegate.h
//  SponsorPay iOS Test App
//
//  Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSampleViewController;

@interface SPSampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *viewController;

@property (nonatomic, strong) NSString *lastCredentialsToken;

- (void)showSDKException:(NSException *)exception;

@end

