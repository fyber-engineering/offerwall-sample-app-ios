//
//  SPMBEViewController.m
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPMBEViewController.h"
#import "SPMBEViewController_private.h"


// SponsorPay Test App.
#import "SPStrings.h"

// TODO: ENABLE_MOCK controls the presence of SponsorPay's mock SDK. But now, in
//       the mock configuration view controller, there will be Flurry related
//       settings. Rename? ENABLE_TEST? Split and use multiple macros?

@implementation SPMBEViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)requestOffers
{
    @try {
        [self.brandEngageClient requestOffersForPlacementId:self.placementId.text];
        [self showActivityIndication];
        NSLog(@"Requesting offers...");
        [self flashView:self.mainGroup];
    }
    @catch (NSException *exception)
    {
        [self showSDKException:exception];
    }
}

- (SPBrandEngageClient *)brandEngageClient
{
    self.brandEngageClient = [SponsorPaySDK brandEngageClientForCredentials:self.lastCredentialsToken];
    _brandEngageClient.delegate = self;

    return _brandEngageClient;
}

- (IBAction)start
{
    @try {
        self.brandEngageClient.shouldShowRewardNotificationOnEngagementCompleted = self.engagementCompletedNotificationSwitch.on;
        [self.brandEngageClient startWithParentViewController:self];
    }
    @catch (NSException *exception)
    {
        [self showSDKException:exception];
    }
}

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient didReceiveOffers:(BOOL)areOffersAvailable
{
    self.startButton.enabled = areOffersAvailable;
    [self stopActivityIndication];
    NSLog(areOffersAvailable ? @"Offers are available" : @"No offers available");
}

- (void)brandEngageClient:(SPBrandEngageClient *)brandEngageClient didChangeStatus:(SPBrandEngageClientStatus)newStatus
{
    self.startButton.enabled = NO;
    [self stopActivityIndication];

    NSString *statusName;

    switch (newStatus) {
    case STARTED:
        statusName = @"STARTED";
        break;
    case CLOSE_FINISHED:
        statusName = @"CLOSE_FINISHED";
        break;
    case CLOSE_ABORTED:
        statusName = @"CLOSE_ABORTED";
        break;
    case ERROR:
        statusName = @"ERROR";
        NSError *error = [NSError errorWithDomain:@"com.sponsorpay.mobileBrandEngageError" code:-1009 userInfo:@{NSLocalizedDescriptionKey: @"No internet connection"}];
            [self handleError:error];
        break;
    }

    NSLog(@"Brand engage client changed status to: %@", statusName);
}

- (void)viewDidUnload
{
    [self setStartButton:nil];
    [self setEngagementCompletedNotificationSwitch:nil];
    [self setMainGroup:nil];
    [super viewDidUnload];
}

- (void)handleError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];

    [alert show];
}

@end
