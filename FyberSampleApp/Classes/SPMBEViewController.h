//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
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
