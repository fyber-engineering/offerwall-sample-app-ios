//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "OfferWallViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"


@interface OfferWallViewController ()



@end


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
    // Create an instance of the FYBOfferWallViewController
    FYBOfferWallViewController *offerWallViewController = [[FYBOfferWallViewController alloc] init];
    
    // You can give the user the possibility to close the Offer Wall while it's loading
    // offerWallViewController.showCloseButtonOnLoad = YES;

    // If the user is redirected to an ad, you can decide whether or not the Offer Wall is automatically dismissed or not with this property
    offerWallViewController.shouldDismissOnRedirect = YES;

    // With this property, a native close button is shown while the offer wall is loading.
    offerWallViewController.showCloseButtonOnLoad = YES;

    // Show the Offer Wall
    [offerWallViewController presentFromViewController:self animated:YES completion:^{
        // Code executed when the Offer Wall is presented
        NSLog(@"Offer was presented");
    } dismiss:^{
        // Code executed when the Offer Wall is dismissed
        NSLog(@"Offer is dismissed");
        [self.showButton fyb_setTitle:@"Offer Wall\ndismissed" restoreTitle:@"Show\nOffer Wall"];
    }];

}

@end
