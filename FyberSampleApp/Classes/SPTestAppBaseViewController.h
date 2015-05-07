//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
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
