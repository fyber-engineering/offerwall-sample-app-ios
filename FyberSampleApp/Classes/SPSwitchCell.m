//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPSwitchCell.h"

@implementation SPSwitchCell

- (IBAction)switchChanged:(id)sender {
    [self.delegate didChangeSwitchView:self];
}

@end
