//
//  SPOfferWallLaunchViewController.h
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPTestAppBaseViewController.h"

@interface SPOfferWallLaunchViewController : SPTestAppBaseViewController <SPOfferWallViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISwitch *closeOnFinishSwitch;

@property (nonatomic, weak) IBOutlet UISwitch *showCloseButtonOnLoad;

@property (nonatomic, weak) IBOutlet UIView *parametersGroup;
@property (nonatomic, weak) IBOutlet UIButton *launchOfferWallButton;

@property (nonatomic, weak) IBOutlet UITextField *placementId;

- (IBAction)launchOfferWall;

@end
