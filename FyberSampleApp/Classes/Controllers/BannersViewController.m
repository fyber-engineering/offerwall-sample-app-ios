//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "BannersViewController.h"
#import "FyberSDK.h"
#import "UIButton+FYBButton.h"
#import "UIColor+FYBColor.h"
#import "FYBAdMob.h"
#import "FYBFacebookAudienceNetwork.h"

@interface BannersViewController ()<FYBBannerControllerDelegate>

@property (nonatomic, weak) UIView *bannerView;

@end

@implementation BannersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.showButton fyb_setTitle:@"Show\nBanner" backgroundColor:[UIColor fyb_brownColor] animated:NO];
    self.bannerPlacementViewHeightConstraint.constant = 0;
}


- (void)requestBanner
{
    [self.showButton fyb_setTitle:@"Getting\nOffers\n..." backgroundColor:[UIColor fyb_brownColor]];

    FYBBannerController *bannerController = [FyberSDK bannerController];
    NSDictionary *bannerSizes = @{
                                  FYBAdMobNetworkName : [FYBBannerSize adMobSmartPortrait],
                                  FYBFacebookNetworkName : [FYBBannerSize facebookSmartx50]
                                  };

    bannerController.delegate = self;
    [bannerController requestBannerWithSizes:bannerSizes];
}

- (void)destroyBanner
{
    [[FyberSDK bannerController] destroyBanner];
    self.bannerView = nil;
    self.bannerPlacementViewHeightConstraint.constant = 0;

    [self.showButton fyb_setTitle:@"Show\nBanner" backgroundColor:[UIColor fyb_brownColor] animated:YES];
}

#pragma mark - Actions

- (IBAction)showOrDestroyBanner:(id)sender
{
    if (!self.bannerView) {
        [self requestBanner];
    } else {
        [self destroyBanner];
    }
}

#pragma mark - FYBBannerControllerDelegate

- (void)bannerControllerDidReceiveBanner:(FYBBannerController *)bannerController
{
    self.bannerView = bannerController.bannerView;
    self.bannerPlacementViewHeightConstraint.constant = CGRectGetHeight(self.bannerView.frame);

    CGRect bannerFrame = self.bannerView.frame;
    bannerFrame.origin = CGPointZero;
    self.bannerView.frame = bannerFrame;

    [self.bannerPlacementView addSubview:self.bannerView];
    [self updateNavigationBarHeight];
    
    [self.showButton fyb_setTitle:@"Destroy\nBanner" backgroundColor:[UIColor fyb_orangeColor]];
}

- (void)bannerController:(FYBBannerController *)bannerController didFailToReceiveBannerWithError:(NSError *)error
{
    [self.showButton fyb_setTitle:@"No\nbanners" backgroundColor:[UIColor fyb_brownColor] restoreTitle:@"Show\nBanner"];
}

#pragma mark - Orientation changes

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self updateNavigationBarHeight];
}

- (void)updateNavigationBarHeight
{
    CGFloat navigationBarHeight = 64;
    if (self.bannerView && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        navigationBarHeight = 32;
    }
    
    self.navigationBarHeightConstraint.constant = navigationBarHeight;
}

@end
