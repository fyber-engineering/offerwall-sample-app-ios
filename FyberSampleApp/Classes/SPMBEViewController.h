//
//  SPMBEViewController.h
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPMBEViewController : SPTestAppBaseViewController <SPBrandEngageClientDelegate>

@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UISwitch *engagementCompletedNotificationSwitch;
@property (nonatomic, weak) IBOutlet UIView *mainGroup;

@property (nonatomic, weak) IBOutlet UITextField *placementId;

- (IBAction)requestOffers;
- (IBAction)start;

@end
