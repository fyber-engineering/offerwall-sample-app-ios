//
//  SPDoubleTextFieldCell.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 28/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPDoubleTextFieldCell.h"

@implementation SPDoubleTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
