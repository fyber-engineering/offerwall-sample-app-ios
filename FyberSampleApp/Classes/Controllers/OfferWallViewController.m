//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "OfferWallViewController.h"
#import "FyberSDK.h"


@interface OfferWallViewController ()

@property (nonatomic, weak) IBOutlet UIButton *showButton;

@end


@implementation OfferWallViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (IBAction)showOfferWall:(id)sender
{
    NSLog(@"Showing Offer Wall");
    // Create an instance of the FYBOfferWallViewController
    FYBOfferWallViewController *offerWallViewController = [[FYBOfferWallViewController alloc] init];
    
    // You can give the user the possibility to close the Offer Wall while it's loading
    // offerWallViewController.showCloseButtonOnLoad = YES;
    
    // Show the Offer Wall
    [offerWallViewController presentFromViewController:self animated:YES completion:^{
        // Code executed when the Offer Wall is presented
        NSLog(@"Offer was presented");
    } dismiss:^{
        // Code executed when the Offer Wall is dismissed
        NSLog(@"Offer is dismissed");
    }];

}

@end
