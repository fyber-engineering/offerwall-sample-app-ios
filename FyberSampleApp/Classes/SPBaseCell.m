//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
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
