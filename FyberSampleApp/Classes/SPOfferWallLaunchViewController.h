//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
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
