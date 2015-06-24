//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>


@interface InterstitialsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *requestButton;

#pragma mark - Actions

- (IBAction)requestOrShowInterstitial:(id)sender;

@end

