//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "OfferWallViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"


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
    
    // Show a close button while the Offer Wall is loading
    offerWallViewController.showCloseButtonOnLoad = YES;

    // Dismiss the Offer Wall when the user leaves your application
    offerWallViewController.shouldDismissOnRedirect = YES;

    // Show the Offer Wall
    [offerWallViewController presentFromViewController:self animated:YES completion:^{
        
        // Code executed when the Offer Wall is presented
        NSLog(@"Offer was presented");
        
    } dismiss:^{
        
        // Code executed when the Offer Wall is dismissed
        NSLog(@"Offer is dismissed");
        [self.showButton fyb_setTitle:@"Offer Wall\nDismissed" restoreTitle:@"Show\nOffer Wall"];
        
    }];
}

@end
