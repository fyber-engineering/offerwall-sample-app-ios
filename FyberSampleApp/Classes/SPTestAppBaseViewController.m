//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPTestAppBaseViewController.h"
#import "SPSampleAppDelegate.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.2;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
//static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
//static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface SPTestAppBaseViewController ()

@property (weak) UITextField *activeField;
@property (assign) CGFloat animatedDistance;
@property (assign) BOOL isKeyboardVisible;

@end

@implementation SPTestAppBaseViewController
{
    CGRect _keyboardBounds;
}

#pragma mark - Shared data and functionality among test app VCs

- (void)setLastCredentialsToken:(NSString *)token
{
    [self testAppDelegate].lastCredentialsToken = token;
}

- (NSString *)lastCredentialsToken
{
    return [self testAppDelegate].lastCredentialsToken;
}

- (void)showSDKException:(NSException *)exception
{
    [[self testAppDelegate] showSDKException:exception];
}

- (SPSampleAppDelegate *)testAppDelegate
{
    return (SPSampleAppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (void)showActivityIndication
{
    UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;
}

- (void)stopActivityIndication
{
    UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = NO;
}

- (void)setBackgroundTextureWithName:(NSString *)imageFileName
{
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:imageFileName]];
}

- (void)flashView:(UIView *)view
{
    static NSTimeInterval flashHighlightHalfDuration = .3;
    UIColor *originalColor = view.backgroundColor;
    UIColor *highlightColor = [UIColor colorWithRed:0
                                              green:.7
                                               blue:0
                                              alpha:.3];
    
    void(^firstAnimation)(void) = ^{
        view.backgroundColor = highlightColor;
    };
    
    void(^reverseAnimation)(void) = ^{
        view.backgroundColor = originalColor;
    };
    
    
    [UIView animateWithDuration:flashHighlightHalfDuration
                     animations:firstAnimation
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:flashHighlightHalfDuration
                                          animations:reverseAnimation];
                     }
     ];

}

#pragma mark - Keyboard management

- (void)keyboardDidShow:(NSNotification *)notification
{
    self.isKeyboardVisible = YES;
    
    // Retrieve the keyboard bounds via the userInfo dictionary
    NSDictionary *userInfo = [notification userInfo];
    [(NSValue *)[userInfo objectForKey:
                 @"UIKeyboardBoundsUserInfoKey"] getValue:&_keyboardBounds];

    [self ensureActiveTextFieldVisible];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.isKeyboardVisible = NO;
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)subscribeToKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)unsubscribeFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
}

- (void)ensureActiveTextFieldVisible
{
    if (!self.isKeyboardVisible)
        return;
    
    UITextField *textField = self.activeField;
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;

    if (isnan(heightFraction) || heightFraction < 0.0) {
        heightFraction = 0.0;
    } else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }

    self.animatedDistance = floor(_keyboardBounds.size.height * heightFraction);

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;

    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view setFrame:viewFrame];
    } completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
    return YES;
}

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBackgroundTextureWithName:@"dvsup.png"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unsubscribeFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Orientation management

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#endif

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
