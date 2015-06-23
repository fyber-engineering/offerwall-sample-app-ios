//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"


static NSTimeInterval const FYBButtonTextDuration = 3.0;

@implementation UIButton (FYBButton)

- (void)fyb_setTitle:(NSString *)title restoreTitle:(NSString *)restoreTitle
{
    [self fyb_setTitle:title backgroundColor:nil restoreTitle:restoreTitle];
}

- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color restoreTitle:(NSString *)restoreTitle
{

    [self fyb_setTitle:title backgroundColor:color];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (FYBButtonTextDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:restoreTitle forState:UIControlStateNormal];
        });
    });
}

- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color
{
    [UIView animateWithDuration:0.5 animations:^{
        if (color) {
            [self setBackgroundColor:color];
        }
        [self setTitle:title forState:UIControlStateNormal];
    }];
}

@end