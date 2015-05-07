//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPInterstitialLaunchViewController.h"
#import "SPLogger.h"

#import "SPStrings.h"


@interface SPInterstitialLaunchViewController ()

@property (readonly, strong, nonatomic) SPInterstitialClient *interstitialClient;

@end

@implementation SPInterstitialLaunchViewController


#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Actions

- (IBAction)requestInterstitial:(id)sender
{
    @try {
        [self showActivityIndication];
        [SponsorPaySDK checkInterstitialAvailable:self placementId:self.placementId.text];
    }
    @catch (NSException *exception)
    {
        [self showSDKException:exception];
    }
}

- (IBAction)launchInterstitial:(id)sender
{
    @try {
        [SponsorPaySDK showInterstitialFromViewController:self];
    }
    @catch (NSException *exception)
    {
        [self showSDKException:exception];
    }
}

#pragma mark - SPInterstitialClientDelegate

- (void)interstitialClient:(SPInterstitialClient *)client canShowInterstitial:(BOOL)canShowInterstitial
{
    LogInvocation;
    self.launchInterstitialButton.enabled = canShowInterstitial;
    [self stopActivityIndication];
}

- (void)interstitialClientDidShowInterstitial:(SPInterstitialClient *)client
{
    LogInvocation;
}

- (void)interstitialClient:(SPInterstitialClient *)client didDismissInterstitialWithReason:(SPInterstitialDismissReason)dismissReason
{
    LogInvocation;
    self.launchInterstitialButton.enabled = NO;

    // Dismiss reason
    NSString *desc =
    [NSString stringWithFormat:@"Interstitial dismissed with reason: %@", SPStringFromInterstitialDismissReason(dismissReason)];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Interstitial result" message:desc delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alertView show];
}

- (void)interstitialClient:(SPInterstitialClient *)client didFailWithError:(NSError *)error
{
    LogInvocation;
    NSLog(@"error=%@", error);
    NSString *desc = [NSString stringWithFormat:@"Interstitial client failed with error: %@", error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Interstitial error"
                                                        message:desc
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

NSString* SPStringFromInterstitialDismissReason(SPInterstitialDismissReason reason)
{
    switch (reason) {
        case SPInterstitialDismissReasonUnknown:
            return @"SPInterstitialDismissReasonUnknown";
        case SPInterstitialDismissReasonUserClickedOnAd:
            return @"SPInterstitialDismissReasonUserClickedOnAd";
        case SPInterstitialDismissReasonUserClosedAd:
            return @"SPInterstitialDismissReasonUserClosedAd";
        default:
            return @"SPInterstitialDismissReasonUnknown";
    }
}

@end

