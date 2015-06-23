//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "UIButton+FYBButton.h"


static NSTimeInterval const FYBButtonTextDuration = 3.0;

@implementation UIButton (FYBButton)

- (void)fyb_setTitle:(NSString *)title forState:(UIControlState)state restoreTitle:(NSString *)restoreTitle
{
    [self fyb_setTitle:title forState:state duration:FYBButtonTextDuration restoreTitle:restoreTitle];
}

- (void)fyb_setTitle:(NSString *)title forState:(UIControlState)state duration:(NSTimeInterval)duration restoreTitle:(NSString *)restoreTitle
{
    [self setTitle:title forState:UIControlStateNormal];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:restoreTitle forState:state];
        });
    });
}

@end