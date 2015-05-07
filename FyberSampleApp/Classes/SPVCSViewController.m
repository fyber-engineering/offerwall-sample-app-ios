//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPVCSViewController.h"

@interface SPVCSViewController ()

@property (strong) NSString *latestUsedVCSTransactionId;

@end

@implementation SPVCSViewController {
    CGRect _sendRequestGroupOriginalFrame;
    CGRect _transactionIDsGroupOriginalFrame;
    CGRect _deltaOfCoinsGroupOriginalFrame;
}

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
    _sendRequestGroupOriginalFrame = self.sendRequestGroup.frame;
    _transactionIDsGroupOriginalFrame = self.transactionIDsGroup.frame;
    _deltaOfCoinsGroupOriginalFrame = self.deltaOfCoinsGroup.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sendDeltaOfCoinsRequest
{
    @try {
        SPVirtualCurrencyServerConnector *vcsConnector =
        [SponsorPaySDK VCSConnectorForCredentials:self.lastCredentialsToken];

        vcsConnector.delegate = self;
        [vcsConnector fetchDeltaOfCoinsWithCurrencyId:self.currencyNameField.text];
        self.latestUsedVCSTransactionId = vcsConnector.latestTransactionId;

        [self showActivityIndication];
        [self clearDisplayedRequestResponseData];
        [self flashView:self.sendRequestGroup];
    } @catch (NSException *exception) {
        [self showSDKException:exception];
    }
}

- (void)clearDisplayedRequestResponseData
{
    self.requestLTIDView.text = @"";
    self.responseLTIDView.text = @"";
    self.responseDeltaOfCoinsView.text = @"";
}

- (void)virtualCurrencyConnector:(SPVirtualCurrencyServerConnector *)vcConnector
  didReceiveDeltaOfCoinsResponse:(double)deltaOfCoins
                      currencyId:(NSString *)currencyId
                    currencyName:(NSString *)currencyName
             latestTransactionId:(NSString *)transactionId
{
    [self stopActivityIndication];
    
    self.requestLTIDView.text = self.latestUsedVCSTransactionId;
    self.responseLTIDView.text = transactionId;
    self.responseDeltaOfCoinsView.text = [NSString stringWithFormat:@"%.2f", deltaOfCoins];
}

- (void)virtualCurrencyConnector:(SPVirtualCurrencyServerConnector *)vcConnector
                 failedWithError:(SPVirtualCurrencyRequestErrorType)error
                       errorCode:(NSString *)errorCode
                    errorMessage:(NSString *)errorMessage
{
    [self stopActivityIndication];
    
    NSString *errorType;
    
    switch (error) {
        case NO_ERROR:
            errorType = @"NO_ERROR";
            break;
        case ERROR_NO_INTERNET_CONNECTION:
            errorType = @"ERROR_NO_INTERNET_CONNECTION";
            break;
        case ERROR_INVALID_RESPONSE:
            errorType = @"ERROR_INVALID_RESPONSE";
            break;
        case
            ERROR_INVALID_RESPONSE_SIGNATURE:
            errorType = @"ERROR_INVALID_RESPONSE_SIGNATURE";
            break;
        case SERVER_RETURNED_ERROR:
            errorType = @"SERVER_RETURNED_ERROR";
            break;
        case ERROR_OTHER:
            errorType = @"ERROR_OTHER";
            break;
        default:
            errorType = [NSString stringWithFormat:@"%@", @(error)];
            break;
    }
    
    NSString *formattedError = [NSString stringWithFormat:@"%@\n%@\n%@", errorType, errorCode, errorMessage];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error in VCS Request / Response"
                                                     message:formattedError
                                                    delegate:self cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustUIToInterfaceOrientation:toInterfaceOrientation];
}

- (void)adjustUIToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    static const CGFloat halfMargin = 2;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect leftTopBlock = self.sendRequestGroup.frame;
        leftTopBlock.origin.x = halfMargin *2;
        leftTopBlock.size.width = (self.view.frame.size.width / 2) - (3 * halfMargin);
        self.sendRequestGroup.frame = leftTopBlock;
       
        CGRect rightBlock = self.transactionIDsGroup.frame;
        rightBlock.size.width = leftTopBlock.size.width;
        rightBlock.origin.x = leftTopBlock.origin.x + leftTopBlock.size.width + (2 * halfMargin);
        rightBlock.origin.y = leftTopBlock.origin.y;
        self.transactionIDsGroup.frame = rightBlock;
        
        CGRect leftBottomBlock = self.deltaOfCoinsGroup.frame;
        leftBottomBlock.origin.x = leftTopBlock.origin.x;
        leftBottomBlock.origin.y = leftTopBlock.origin.y + leftTopBlock.size.height + (2 * halfMargin);
        leftBottomBlock.size.width = leftTopBlock.size.width;
        self.deltaOfCoinsGroup.frame = leftBottomBlock;
        
    } else {
        self.sendRequestGroup.frame = _sendRequestGroupOriginalFrame;
        self.transactionIDsGroup.frame = _transactionIDsGroupOriginalFrame;
        self.deltaOfCoinsGroup.frame = _deltaOfCoinsGroupOriginalFrame;
    }
}

- (void)viewDidUnload {
    [self setSendRequestGroup:nil];
    [self setRequestLTIDView:nil];
    [self setResponseLTIDView:nil];
    [self setResponseDeltaOfCoinsView:nil];
    [self setTransactionIDsGroup:nil];
    [self setDeltaOfCoinsGroup:nil];
    [super viewDidUnload];
}
@end
