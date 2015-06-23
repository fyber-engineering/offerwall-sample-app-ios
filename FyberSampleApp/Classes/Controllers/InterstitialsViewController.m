//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "InterstitialsViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"


@interface InterstitialsViewController () <FYBInterstitialControllerDelegate>


@property(nonatomic) BOOL didReceiveOffers;
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

- (IBAction)requestOrShowInterstitial:(id)sender
{
    if (self.didReceiveOffers) {
        [self showInterstitial];
    } else {
        [self requestInterstitial];
    }
}


- (void)requestInterstitial
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

- (void)showInterstitial
{
    // Play the received interstitial
    [[FyberSDK interstitialController] presentInterstitialFromViewController:self];
}

#pragma mark FYBInterstitialControllerDelegate - Request Interstitial

- (void)interstitialControllerDidReceiveInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Did receive offer");
    self.didReceiveOffers = YES;
    [self.requestButton fyb_setTitle:@"Show Interstitial" backgroundColor:[UIColor fyb_orangeColor]];

}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToReceiveInterstitialWithError:(NSError *)error
{
    NSLog(@"Did not receive any offer");
    self.didReceiveOffers = NO;
    [self.requestButton fyb_setTitle:@"No interstitials" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request Interstitial"];

}

#pragma mark FYBInterstitialControllerDelegate  - Show Interstitial

- (void)interstitialControllerDidPresentInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Interstitial Presented");
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didDismissInterstitialWithReason:(FYBInterstitialDismissReason)reason
{
    self.didReceiveOffers = NO;
    [self.requestButton fyb_setTitle:@"Interstitials dismissed" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request Interstitial"];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToPresentInterstitialWithError:(NSError *)error
{
    self.didReceiveOffers = NO;
    [self.requestButton fyb_setTitle:@"Showing Interstitial Failed" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request Interstitial"];
}


@end
