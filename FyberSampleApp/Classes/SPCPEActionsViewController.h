//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPTestAppBaseViewController.h"

@interface SPCPEActionsViewController : SPTestAppBaseViewController

@property (strong, nonatomic) IBOutlet UITextField *actionIdField;
@property (strong, nonatomic) IBOutlet UIView *mainGroup;

- (IBAction)reportActionCompleted;

@end
