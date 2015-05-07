//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "SPTestAppBaseViewController.h"

@interface SPStartSDKViewController : SPTestAppBaseViewController<UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *appIdField;
@property (nonatomic, strong) IBOutlet UITextField *userIdField;
@property (nonatomic, strong) IBOutlet UITextField *vcsKeyField;
@property (nonatomic, strong) IBOutlet UITextField *currencyNameField;
@property (nonatomic, strong) IBOutlet UISwitch *showCoinsNotificationSwitch;
@property (nonatomic, strong) IBOutlet UIView *startSDKGroup;
@property (nonatomic, strong) IBOutlet UIView *credentialsSettingsGroup;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)startSDK;
- (IBAction)userDidEnterCurrencyName:(UITextField *)sender;
- (IBAction)showCoinsNotificationValueChanged:(UISwitch *)sender;

- (IBAction)clearPersistedSDKData;


@end
