//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "RewardedVideosViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"


@interface RewardedVideosViewController () <FYBRewardedVideoControllerDelegate, FYBVirtualCurrencyClientDelegate>

@property(nonatomic, assign) BOOL didReceiveOffers;

@end


@implementation RewardedVideosViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.requestButton fyb_setTitle:@"Request\nVideo" backgroundColor:[UIColor fyb_brownColor] animated:NO];
}


#pragma mark - Actions

- (IBAction)requestOrShowRewardedVideos:(id)sender
{
    if (self.didReceiveOffers) {
        [self showRewardedVideo];
    } else {
        [self requestRewardedVideo];
    }
}

- (void)requestRewardedVideo
{
    self.requestButton.enabled = NO;
    
    NSLog(@"Requesting Rewarded Video");

    [self.requestButton fyb_setTitle:@"Getting\nOffers\n..." backgroundColor:[UIColor fyb_brownColor]];

    // Get the Rewarded Video Controller
    FYBRewardedVideoController *rewardedVideoController = [FyberSDK rewardedVideoController];

    // Set the delegate of the controller in order to be notified of the controller's state changes
    rewardedVideoController.delegate = self;

    // Enable or disable a "toast" message shown to the user after the video is fully watched
    rewardedVideoController.shouldShowToastOnCompletion = YES;

    // Set the controller's virtualCurrencyClientDelegate to request virtual currency automatically requested after the user engagement
    rewardedVideoController.virtualCurrencyClientDelegate = self;

    // Request a Rewarded Video
    FYBRequestParameters *parameters = [[FYBRequestParameters alloc] init];
    
    // Add an optional Placement ID, Currency ID or Custom Parameters to your request
    // parameters.placementId = @"PLACEMENT_ID";
    // parameters.currencyId = @"CURRENCY_ID";
    // [parameters addCustomParameterWithKey:@"param1Key" value:@"param1Value"];
    
    [rewardedVideoController requestVideoWithParameters:parameters];
}

- (void)showRewardedVideo
{
    // Play the received rewarded video
    [[FyberSDK rewardedVideoController] presentRewardedVideoFromViewController:self];
}


#pragma mark FYBRewardedVideoControllerDelegate - Request Video

- (void)rewardedVideoControllerDidReceiveVideo:(FYBRewardedVideoController *)rewardedVideoController
{
    NSLog(@"Did receive offer");
    
    self.requestButton.enabled = YES;
    self.didReceiveOffers = YES;

    [self.requestButton fyb_setTitle:@"Show\nVideo" backgroundColor:[UIColor fyb_orangeColor]];
}

- (void)rewardedVideoController:(FYBRewardedVideoController *)rewardedVideoController didFailToReceiveVideoWithError:(NSError *)error
{
    NSLog(@"Did not receive any offer");
    
    self.requestButton.enabled = YES;
    self.didReceiveOffers = NO;
    
    [self.requestButton fyb_setTitle:@"No\nVideo" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request\nVideo"];
}


#pragma mark FYBRewardedVideoControllerDelegate - Show Video

- (void)rewardedVideoControllerDidStartVideo:(FYBRewardedVideoController *)rewardedVideoController
{
    NSLog(@"Video Started");
}

- (void)rewardedVideoController:(FYBRewardedVideoController *)rewardedVideoController didDismissVideoWithReason:(FYBRewardedVideoControllerDismissReason)reason
{
    self.didReceiveOffers = NO;
    
    [self.requestButton fyb_setTitle:@"Video Ended" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request\nVideo"];
}

- (void)rewardedVideoController:(FYBRewardedVideoController *)rewardedVideoController didFailToStartVideoWithError:(NSError *)error
{
    self.didReceiveOffers = NO;
    
    [self.requestButton fyb_setTitle:@"Showing Video Failed" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Request\nVideo"];
}


#pragma mark - FYBVirtualCurrencyClientDelegate

- (void)virtualCurrencyClient:(FYBVirtualCurrencyClient *)client didReceiveResponse:(FYBVirtualCurrencyResponse *)response
{
    NSLog(@"Received %@ %@", @(response.deltaOfCoins), response.currencyName);
}

- (void)virtualCurrencyClient:(FYBVirtualCurrencyClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"Failed to receive virtual currency %@", error);
}

@end
