//
//
// Copyright (c) 2020 Fyber. All rights reserved.
//
//

#import "OfferWallViewController.h"
#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"
@import FairBidSDK.Swift;
@import FairBidSDK.OfferWall;

@implementation OfferWallViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.showButton fyb_setTitle:@"Show\nOffer Wall" backgroundColor:[UIColor fyb_orangeColor] animated:NO];
}


#pragma mark - Actions

- (IBAction)showOfferWall:(id)sender
{
    NSLog(@"Showing Offer Wall");

    [self.showButton setTitle:@"Showing Offer Wall" forState:UIControlStateNormal];
    // Create OFWShowOptions object
    OFWShowOptions *showOptions = [OFWShowOptions optionsWithCloseOnRedirect:YES
                                                              viewController:self
                                                                    animated:YES
                                                                customParams:nil];
    // Pass showOptions to OfferWalls show api
    [OfferWall showWithOptions:showOptions];
}

@end
