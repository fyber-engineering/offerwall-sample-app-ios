//
//  SPOfferWallLaunchViewController.h
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPOfferWallLaunchViewController.h"

static NSString *const SPPersistedCloseOnFinishKey = @"SPPersistedCloseOnFinishKey";


@interface SPOfferWallLaunchViewController ()

@end

@implementation SPOfferWallLaunchViewController {
    CGRect _parametersGroupFrame;
    CGRect _launchOfferWallButtonFrame;
}

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
    _parametersGroupFrame = self.parametersGroup.frame;
    _launchOfferWallButtonFrame = self.launchOfferWallButton.frame;
    [self restorePersistedUserEnteredValues];
}


- (void)viewDidUnload
{
    [self setCloseOnFinishSwitch:nil];
    [self setParametersGroup:nil];
    [self setLaunchOfferWallButton:nil];
    [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self adjustUIToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}


- (void)viewWillDisappear:(BOOL)animated // TODO: move up
{
    [super viewWillDisappear:animated];
    [self persistUserEnteredValues];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (IBAction)launchOfferWall
{
    @try {
        SPOfferWallViewController *offerWallVC = [SponsorPaySDK offerWallViewControllerForCredentials:self.lastCredentialsToken];
        offerWallVC.delegate = self;
        offerWallVC.shouldFinishOnRedirect = self.closeOnFinishSwitch.on;
        offerWallVC.showCloseButtonOnLoad = self.showCloseButtonOnLoad.on;
        [offerWallVC showOfferWallWithParentViewController:self placementId:self.placementId.text completion:^(int status) {
            NSLog(@"Did receive SPOfferWallViewController callback with status: %d", status);
        }];
    }
    @catch (NSException *exception)
    {
        [self showSDKException:exception];
    }
}

#pragma mark - Private

- (void)persistUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.closeOnFinishSwitch.on forKey:SPPersistedCloseOnFinishKey];
    [defaults synchronize];
}


- (void)restorePersistedUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.closeOnFinishSwitch.on = [defaults boolForKey:SPPersistedCloseOnFinishKey];
}


#pragma mark - Orientation

- (void)adjustUIToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    static const CGFloat halfMargin = 2;

    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect leftBlock = self.parametersGroup.frame;
        leftBlock.origin.x = halfMargin * 2;
        leftBlock.size.width = (self.view.frame.size.width / 2) - (3 * halfMargin);
        self.parametersGroup.frame = leftBlock;

        CGRect launchOFWBlock = self.launchOfferWallButton.frame;
        launchOFWBlock.origin.x = leftBlock.origin.x;
        launchOFWBlock.origin.y = leftBlock.origin.y + leftBlock.size.height + 2 * halfMargin;
        launchOFWBlock.size.width = leftBlock.size.width;
        self.launchOfferWallButton.frame = launchOFWBlock;
    } else {
        self.parametersGroup.frame = _parametersGroupFrame;
        self.launchOfferWallButton.frame = _launchOfferWallButtonFrame;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self adjustUIToInterfaceOrientation:toInterfaceOrientation];
}

@end
