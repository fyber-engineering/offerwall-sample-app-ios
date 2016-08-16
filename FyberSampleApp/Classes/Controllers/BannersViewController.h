//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface BannersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIView *bannerPlacementView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerPlacementViewHeightConstraint;

@end
