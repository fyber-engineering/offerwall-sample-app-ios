//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//


#import "InterstitialsViewController.h"
#import "FyberSDK.h"


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
    // Fetch the Interstitial Controller
    FYBInterstitialController *interstitialController = [FyberSDK interstitialController];
    interstitialController.delegate = self;
    [interstitialController requestInterstitial];
}


#pragma mark - FYBInterstitialControllerDelegate

- (void)interstitialControllerDidReceiveInterstitial:(FYBInterstitialController *)interstitialController
{
    NSLog(@"Showing Interstitial");
    [interstitialController presentInterstitialFromViewController:self];
}

- (void)interstitialController:(FYBInterstitialController *)interstitialController didFailToReceiveInterstitialWithError:(NSError *)error
{
    NSLog(@"Did not receive offer");
}


@end
