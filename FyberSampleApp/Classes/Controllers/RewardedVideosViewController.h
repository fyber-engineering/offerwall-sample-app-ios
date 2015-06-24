//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <UIKit/UIKit.h>


@interface RewardedVideosViewController : UIViewController

@property(nonatomic, weak) IBOutlet UIButton *requestButton;

#pragma mark - Actions

- (IBAction)requestOrShowRewardedVideos:(id)sender;

@end

