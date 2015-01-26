//
//  SPBaseCell.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 24/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPBaseCell.h"

@implementation SPBaseCell

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect newFrame                 = self.textLabel.frame;
    newFrame.origin.y               = 0.f;
    newFrame.size.height            = 44.f;
    self.textLabel.frame            = newFrame;
    self.textLabel.backgroundColor  = [UIColor clearColor];
}

@end
