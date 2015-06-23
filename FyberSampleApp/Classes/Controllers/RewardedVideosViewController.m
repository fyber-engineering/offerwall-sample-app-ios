//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "RewardedVideosViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"


@interface RewardedVideosViewController () <FYBRewardedVideoControllerDelegate, FYBVirtualCurrencyClientDelegate>


@end


@implementation RewardedVideosViewController

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

- (IBAction)requestRewardedVideos:(id)sender
{
    NSLog(@"Requesting Rewarded Video");

    [self.requestButton setTitle:@"Getting Offers ..." forState:UIControlStateNormal];

    [self.requestButton titleForState:UIControlStateNormal];

    // Fetch the Rewarded Video Controller
    FYBRewardedVideoController *rewardedVideoController = [FyberSDK rewardedVideoController];

    // Configure the client the way you want (check out the API Reference for more information)
    rewardedVideoController.delegate = self; // self should conform to the `FYBRewardedVideoControllerDelegate` protocol


    // You can enable or disable a "toast" message shown to the user after the video is fully watched
    rewardedVideoController.shouldShowToastForCompletedEngagement = YES;

    // If you set a FYBVirtualCurrencyClientDelegate, the virtual currency will be automatically requested after the user engagement
    // and your delegate will be informed about its results.
    rewardedVideoController.virtualCurrencyClientDelegate = self;

    // Request a Rewarded Video
    [rewardedVideoController requestVideo];
}

#pragma mark FYBRewardedVideoControllerDelegate - Request Video

- (void)rewardedVideoControllerDidReceiveVideo:(FYBRewardedVideoController *)rewardedVideoController
{
    [self.requestButton setTitle:@"Got Offers" forState:UIControlStateNormal];

    // Play the received rewarded video
    [rewardedVideoController presentRewardedVideoFromViewController:self];
}

- (void)rewardedVideoController:(FYBRewardedVideoController *)rewardedVideoController didFailToReceiveVideoWithError:(NSError *)error
{
    [self.requestButton fyb_setTitle:@"No videos" forState:UIControlStateNormal restoreTitle:@"Request Video"];

}



#pragma mark FYBRewardedVideoControllerDelegate - Show Video

- (void)rewardedVideoControllerDidStartVideo:(FYBRewardedVideoController *)rewardedVideoController
{
    [self.requestButton setTitle:@"Showing Video" forState:UIControlStateNormal];
}


- (void)rewardedVideoController:(FYBRewardedVideoController *)rewardedVideoController didDismissVideoWithReason:(FYBRewardedVideoControllerDismissReason)reason
{
    [self.requestButton fyb_setTitle:@"Video ended" forState:UIControlStateNormal restoreTitle:@"Request Video"];
}

- (void)rewardedVideoController:(FYBRewardedVideoController *)rewardedVideoController didFailToShowVideoWithError:(NSError *)error
{
    [self.requestButton fyb_setTitle:@"Showing Video Failed" forState:UIControlStateNormal restoreTitle:@"Request Video"];

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
