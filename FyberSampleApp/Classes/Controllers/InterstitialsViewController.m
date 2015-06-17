//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//


#import "InterstitialsViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"


@interface InterstitialsViewController () <FYBInterstitialControllerDelegate>


@end


@implementation InterstitialsViewController

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

- (IBAction)requestInterstitial:(id)sender
{
    NSLog(@"Requesting Interstitial");
    [self.requestButton setTitle:@"Getting Offers ..." forState:UIControlStateNormal];
    // Fetch the Interstitial Controller
    FYBInterstitialController *interstitialController = [FyberSDK interstitialController];
    interstitialController.delegate = self;
    [interstitialController requestInterstitial];
}


#pragma mark FYBInterstitialControllerDelegate - Request Interstitial

- (void)interstitialControllerDidReceiveInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Showing Interstitial");
    [interstitialController presentInterstitialFromViewController:self];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToReceiveInterstitialWithError:(NSError *)error
{
    [self.requestButton fyb_setTitle:@"No interstitials" forState:UIControlStateNormal restoreTitle:@"Request Interstitial"];
    NSLog(@"Did not receive offer");
}

#pragma mark FYBInterstitialControllerDelegate  - Show Interstitial

- (void)interstitialController:(FYBInterstitialController *)interstitialController didDismissInterstitialWithReason:(FYBInterstitialDismissReason)reason
{
    [self.requestButton fyb_setTitle:@"Interstitials dismissed" forState:UIControlStateNormal restoreTitle:@"Request Interstitial"];
}


@end
