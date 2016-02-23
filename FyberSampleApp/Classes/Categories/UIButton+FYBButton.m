//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"
#import "UIFont+FYBFont.h"


static NSTimeInterval const FYBButtonTextDuration = 3.0;
static NSTimeInterval const FYBButtonAnimationDuration = 0.5;


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
            [self fyb_setTitle:restoreTitle backgroundColor:color];
        });
    });
}

- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color
{
    [self fyb_setTitle:title backgroundColor:color animated:YES];
}

- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color animated:(BOOL)animated
{
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:[UIFont fyb_buttonParagraphAttributes]];
    if (!animated) {
        [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        [self setBackgroundColor:color];
        return;
    }

    if (color) {
        [UIView animateWithDuration:FYBButtonAnimationDuration animations:^{

            [self setBackgroundColor:color];

        }];
    }

    NSTimeInterval duration = FYBButtonAnimationDuration / 2.0;
    [UIView animateWithDuration:duration animations:^{
        self.titleLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self setAttributedTitle:attributedTitle forState:UIControlStateNormal];

        [UIView animateWithDuration:duration animations:^{
            self.titleLabel.alpha = 1.0f;
        }];

    }];

}

@end