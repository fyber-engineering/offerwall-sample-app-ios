//
//  CPEActionsViewController.h
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPCPEActionsViewController : SPTestAppBaseViewController

@property (strong, nonatomic) IBOutlet UITextField *actionIdField;
@property (strong, nonatomic) IBOutlet UIView *mainGroup;

- (IBAction)reportActionCompleted;

@end
