//
//  SPTestAppBaseViewController.h
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SponsorPaySDK.h"

@interface SPTestAppBaseViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *lastCredentialsToken;

- (void)showSDKException:(NSException *)exception;
- (void)showActivityIndication;
- (void)stopActivityIndication;
- (void)setBackgroundTextureWithName:(NSString *)imageFileName;
- (void)flashView:(UIView *)view;

@end
