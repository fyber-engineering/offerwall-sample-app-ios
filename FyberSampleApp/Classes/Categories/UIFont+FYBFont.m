//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "UIFont+FYBFont.h"
#import "UIColor+FYBColor.h"


@implementation UIFont (FYBFont)

+ (UIFont *)fyb_buttonFont
{
    return [UIFont fontWithName:@"Circular-Book" size:18.0];
}

+ (UIFont *)fyb_navigationBarFont
{
    return [UIFont fontWithName:@"Circular-Book" size:20.0];
}

+ (NSDictionary *)fyb_buttonParagraphAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fyb_buttonFont],
            NSForegroundColorAttributeName: [UIColor fyb_textColor],
            NSParagraphStyleAttributeName: paragraphStyle};
    
    return attributes;
}

@end
