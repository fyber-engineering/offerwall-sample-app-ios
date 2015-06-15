//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "RewardedVideosViewController.h"


@interface RewardedVideosViewController ()

@property (nonatomic, weak) IBOutlet UIButton *requestButton;

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
}

- (IBAction)playRewardedVideos:(id)sender
{
    NSLog(@"Playing Rewarded Video");
}

@end
