//
//  SPVCSViewController.h
//  SponsorPay Sample App
//
//  Created by David Davila on 1/14/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPTestAppBaseViewController.h"

@interface SPVCSViewController : SPTestAppBaseViewController<SPVirtualCurrencyConnectionDelegate>

@property (nonatomic, strong) IBOutlet UIView *sendRequestGroup;
@property (nonatomic, strong) IBOutlet UIView *transactionIDsGroup;
@property (nonatomic, strong) IBOutlet UIView *deltaOfCoinsGroup;
@property (nonatomic, strong) IBOutlet UITextView *requestLTIDView;
@property (nonatomic, strong) IBOutlet UITextView *responseLTIDView;
@property (nonatomic, strong) IBOutlet UITextView *responseDeltaOfCoinsView;
@property (nonatomic, strong) IBOutlet UITextField *currencyNameField;

- (IBAction)sendDeltaOfCoinsRequest;

@end
