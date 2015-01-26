//
//  CPEActionsViewController.m
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPCPEActionsViewController.h"

static NSString *const SPPersistedActionIDKey = @"SPPersistedActionIDKey";

@interface SPCPEActionsViewController ()

@end

@implementation SPCPEActionsViewController

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
    [self restorePersistedUserEnteredValues];
}

- (void)viewWillDisappear:(BOOL)animated // TODO: move up
{
    [super viewWillDisappear:animated];
    [self persistUserEnteredValues];
}

- (void)persistUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.actionIdField.text forKey:SPPersistedActionIDKey];
    [defaults synchronize];
}

- (void)restorePersistedUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.actionIdField.text = [defaults valueForKey:SPPersistedActionIDKey];
}

- (void)viewDidUnload
{
    [self setActionIdField:nil];
    [self setMainGroup:nil];
    [super viewDidUnload];
}

- (IBAction)reportActionCompleted
{
    @try {
        [SponsorPaySDK reportActionCompleted:self.actionIdField.text
                              forCredentials:self.lastCredentialsToken];
        [self flashView:self.mainGroup];
    } @catch (NSException *exception) {
        [self showSDKException:exception];
    }
}
@end
