//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>


@interface UIButton (FYBButton)

- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color restoreTitle:(NSString *)restoreTitle;

- (void)fyb_setTitle:(NSString *)title restoreTitle:(NSString *)restoreTitle;

- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color;
- (void)fyb_setTitle:(NSString *)title backgroundColor:(UIColor *)color animated:(BOOL) animated;

@end