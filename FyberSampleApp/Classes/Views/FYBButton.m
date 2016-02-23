//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "FYBButton.h"
#import "UIColor+FYBColor.h"
#import "UIFont+FYBFont.h"


@implementation FYBButton

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    if (self) {
        [self customizeAppearance];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self customizeAppearance];
}

- (void)customizeAppearance
{
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor fyb_textColor].CGColor;
    self.backgroundColor = [UIColor fyb_brownColor];
    self.titleLabel.font = [UIFont fyb_buttonFont];
}

#pragma mark - View Lifecycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2.0f;

}

@end
