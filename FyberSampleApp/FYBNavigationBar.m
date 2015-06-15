//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//


#import "FYBNavigationBar.h"


@implementation FYBNavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {

        NSDictionary * navBarTitleTextAttributes = @{
                                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                                     NSFontAttributeName: [UIFont fontWithName:@"Circular-Book" size:20.0]
                                                     };

        [self setTitleTextAttributes:navBarTitleTextAttributes];

    }

    return self;
}

@end
