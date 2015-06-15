//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//


#import "InterstitialsViewController.h"


@interface InterstitialsViewController ()

@property (nonatomic, weak) IBOutlet UIButton *requestButton;

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
}

- (IBAction)showInterstitial:(id)sender
{
    NSLog(@"Showing Interstitial");
}



@end
