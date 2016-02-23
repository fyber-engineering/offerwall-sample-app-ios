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
    
    [self.requestButton fyb_setTitle:@"Request\nInterstitial" backgroundColor:[UIColor fyb_brownColor] animated:NO];
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
    self.requestButton.enabled = NO;
    
    NSLog(@"Requesting Interstitial");
    
    [self.requestButton fyb_setTitle:@"Getting\nOffers\n..." backgroundColor:[UIColor fyb_brownColor]];
    
    // Get the Interstitial Controller
    FYBInterstitialController *interstitialController = [FyberSDK interstitialController];
    
    // Set the delegate of the controller in order to be notified of the controller's state changes
    interstitialController.delegate = self;

    // Request an Interstitial
    FYBRequestParameters *parameters = [[FYBRequestParameters alloc] init];

    // Add an optional Placement ID or Custom Parameters to your request
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
    
    self.requestButton.enabled = YES;
    self.didReceiveOffers = YES;
    
    [self.requestButton fyb_setTitle:@"Show\nInterstitial" backgroundColor:[UIColor fyb_orangeColor]];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToReceiveInterstitialWithError:(NSError *)error
{
    NSLog(@"Did not receive any offer");
    
    self.requestButton.enabled = YES;
    self.didReceiveOffers = NO;
    
    [self.requestButton fyb_setTitle:@"No\ninterstitials" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request\nInterstitial"];
}


#pragma mark FYBInterstitialControllerDelegate  - Show Interstitial

- (void)interstitialControllerDidPresentInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Interstitial Presented");
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didDismissInterstitialWithReason:(FYBInterstitialControllerDismissReason)reason
{
    self.didReceiveOffers = NO;
    
    [self.requestButton fyb_setTitle:@"Interstitials\ndismissed" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request\nInterstitial"];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToPresentInterstitialWithError:(NSError *)error
{
    self.didReceiveOffers = NO;
    
    [self.requestButton fyb_setTitle:@"Showing Interstitial Failed" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request\nInterstitial"];
}

@end
