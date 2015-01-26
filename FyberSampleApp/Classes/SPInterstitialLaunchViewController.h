//
//  SPInterstitialLaunchViewController.h
//  SponsorPayTestApp
//
//  Created by David Davila on 02/11/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPInterstitialLaunchViewController : SPTestAppBaseViewController<SPInterstitialClientDelegate>

@property (nonatomic, weak) IBOutlet UIButton *requestInterstitialButton;
@property (nonatomic, weak) IBOutlet UIButton *launchInterstitialButton;
@property (nonatomic, weak) IBOutlet UITextField *placementId;

- (IBAction)requestInterstitial:(id)sender;
- (IBAction)launchInterstitial:(id)sender;

@end
