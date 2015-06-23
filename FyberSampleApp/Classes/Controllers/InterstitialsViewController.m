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

    FYBRequestParameters *parameters = [[FYBRequestParameters alloc] init];

    // If you want to add custom parameters or a placement id to your request, you can do it with the following code
    // parameters.placementId = @"PLACEMENT_ID";
    // [parameters addCustomParameterWithKey:@"param1Key" value:@"param1Value"];

    [interstitialController requestInterstitialWithParameters:parameters];

}

#pragma mark FYBInterstitialControllerDelegate - Request Interstitial

- (void)interstitialControllerDidReceiveInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Did not receive offer");
    [interstitialController presentInterstitialFromViewController:self];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToReceiveInterstitialWithError:(NSError *)error
{
    NSLog(@"Did not receive any offer");
    [self.requestButton fyb_setTitle:@"No interstitials" forState:UIControlStateNormal restoreTitle:@"Request Interstitial"];

}

#pragma mark FYBInterstitialControllerDelegate  - Show Interstitial

- (void)interstitialControllerDidPresentInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Interstitial Presented");
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didDismissInterstitialWithReason:(FYBInterstitialDismissReason)reason
{
    [self.requestButton fyb_setTitle:@"Interstitials dismissed" forState:UIControlStateNormal restoreTitle:@"Request Interstitial"];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToPresentInterstitialWithError:(NSError *)error
{
    [self.requestButton fyb_setTitle:@"Showing Interstitial Failed" forState:UIControlStateNormal restoreTitle:@"Request Interstitial"];
}


@end
