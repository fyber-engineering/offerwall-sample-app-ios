//
//  SPSwitchCell.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 21/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPSwitchCell.h"

@implementation SPSwitchCell

- (IBAction)switchChanged:(id)sender {
    [self.delegate didChangeSwitchView:self];
}

@end
