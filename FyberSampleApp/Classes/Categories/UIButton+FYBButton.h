//
// Created by Jan on 17/06/15.
// Copyright (c) 2015 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSTimeInterval const FYBButtonTextDuration;

@interface UIButton (FYBButton)

/**
 *
 * Sets the title for the given state and restores it after a default delay
 *
 */
- (void)fyb_setTitle:(NSString *)title forState:(UIControlState)state restoreTitle:(NSString *) restoreTitle;

@end