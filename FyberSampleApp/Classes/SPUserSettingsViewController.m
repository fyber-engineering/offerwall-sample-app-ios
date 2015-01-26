//
//  SPUserSettingsViewController.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 21/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPUserSettingsViewController.h"
#import "SPUserSettingsModel.h"
#import "SPUserSettingsModel+Mapping.h"
#import "SPUserDynamicTableViewController.h"
#import "SponsorPaySDK.h"
#import "SPSampleAppDelegate.h"
#import "SPUserConstants.h"

static NSString * const SPCellTextField     = @"Cell Text Field";
static NSString * const SPCellSwitch        = @"Cell Switch";
static CGFloat const SPDefaultCellHeight  = 44.f;

#define NAVBAR_HEIGHT (IS_iOS7 ? 64.f : 0.f)

@interface SPUserSettingsViewController () <SPUserSettingsModelDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate>

@property (nonatomic, strong) IBOutlet SPUserSettingsModel  *model;
@property (nonatomic, strong) UIPickerView                  *customPicker;
@property (nonatomic, strong) UIDatePicker                  *datePicker;
@property (nonatomic, strong) NSIndexPath                   *selectedPickerIndexPath;
@property (nonatomic, weak) UIView                          *pickerViewContainer;


// Just to pick up current location
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation SPUserSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register notifications for keyboard observing
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    UINib *nib1 = [UINib nibWithNibName:@"SPTextFieldCell" bundle:nil];
    [self.model.tableView registerNib:nib1 forCellReuseIdentifier:SPCellTextField];

    UINib *nib2 = [UINib nibWithNibName:@"SPSwitchCell" bundle:nil];
    [self.model.tableView registerNib:nib2 forCellReuseIdentifier:SPCellSwitch];

    self.model.delegate = self;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(resetUserData:)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecameActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    addButton.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"User Settings";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setupLocation];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - Actions

-(void)resetUserData:(id)sender {
    SPUser *user = [SponsorPaySDK instance].user;
    [user reset];

    [self.model.tableView reloadData];
}

-(void)dateDidChange:(id)sender {
    [self setValueFromDatePicker];
}

#pragma mark - Notifications

- (void)applicationBecameActive:(id)applicationBecameActive
{
    // reload the location aware picker or cells in case we allows / restricted location in the Preferences
    [self.model.tableView reloadData];
    [self.customPicker reloadAllComponents];
}

#pragma mark - Private

- (void)keyboardWillShow:(NSNotification *)sender
{
    NSDictionary *userInfo      = [sender userInfo];
    CGSize keyboardSize         = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration     = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    if (IS_iOS7) {
        // Retract the picker view
        if (self.selectedPickerIndexPath) {
            self.selectedPickerIndexPath = nil;
            [self hidePickerViewWithCompletionBlock:^{
                [UIView animateWithDuration:duration delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, keyboardSize.height + 5, 0);
                    [self.model.tableView setContentInset:edgeInsets];
                    [self.model.tableView setScrollIndicatorInsets:edgeInsets];
                } completion:nil];
            }];
            [self.model.tableView beginUpdates];
            [self.model.tableView endUpdates];
            return;
        }
    }

    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, keyboardSize.height + 5, 0);
        [self.model.tableView setContentInset:edgeInsets];
        [self.model.tableView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSDictionary *userInfo      = [sender userInfo];
    NSTimeInterval duration     = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, NAVBAR_HEIGHT, 0);
        [self.model.tableView  setContentInset:edgeInsets];
        [self.model.tableView  setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void) showPickerForCell:(SPBaseCell *)cell {
    CGRect frame            = cell.frame;
    frame.size.height       = CGRectGetHeight(self.customPicker.bounds) + SPDefaultCellHeight;  // Get size from custom picker.
                                                                                                // And extra space for label - space of default cell height

    [UIView animateWithDuration:0.35 animations:^{
        cell.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self addPickerForCell:cell];
            [self fadePickersToAlpha:0.f];
            [UIView animateWithDuration:0.35 animations:^{
                [self fadePickersToAlpha:1.f];
            }];
        }
    }];
}

- (void) hidePickerViewWithCompletionBlock:(void(^)())block {
    // Obtain frame of parent view (cell) in order to reset frame's parameters
    SPBaseCell *cell   = (SPBaseCell *)[self.customPicker findSuperViewWithClass:[SPBaseCell class]];
    if (!cell) {
        cell = (SPBaseCell *)[self.datePicker findSuperViewWithClass:[SPBaseCell class]];
        if (!cell) {
            // Nothing to hide :)
            return;
        }
    }

    CGRect frame       = cell.frame;
    frame.size.height  = SPDefaultCellHeight; // Default cell size;

    [UIView animateWithDuration:0.35 animations:^{
        [self fadePickersToAlpha:0.f];
        cell.frame              = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removePickers];
            if (block) {
                block();
            }
        }
    }];
}

- (void) addPickerForCell:(SPBaseCell *)cell {
    if (cell.cellType == SPCellTypeCustomPicker || cell.cellType == SPCellTypeCustomPickerWithSwitch) {
        [cell addSubview:self.customPicker];
        [self.customPicker sizeToFit];
        // Move custom picker a bit below the label
        self.customPicker.transform = CGAffineTransformMakeTranslation(0, SPDefaultCellHeight);
    } else if (cell.cellType == SPCellTypeDatePicker) {
        [cell addSubview:self.datePicker];
        [self.datePicker sizeToFit];
        // Move custom picker a bit below the label
        self.datePicker.transform = CGAffineTransformMakeTranslation(0, SPDefaultCellHeight);

        // We also need to add initial date
        NSDate *bday = [[SponsorPaySDK instance].user birthdate];
        if (bday) {
            self.datePicker.date = bday;
        }
    }
}

- (void) fadePickersToAlpha:(CGFloat)alpha {
    self.customPicker.alpha = alpha;
    self.datePicker.alpha   = alpha;
}

- (void) removePickers {
    [self.customPicker  removeFromSuperview];
    [self.datePicker    removeFromSuperview];
    self.customPicker   = nil;
    self.datePicker     = nil;
}

- (CLLocation *) locationForIndex:(SPUserSampleLocation)index
{
    return [self.model locationForIndex:index];
}

- (void) setValueFromDatePicker {
    SPUser *user = [SponsorPaySDK instance].user;
    NSDate *date = self.datePicker.date;
    [user setBirthdate:date];
    [self.model.tableView reloadData];
}

- (void) setValueFromPicker:(NSInteger)index {
    SPUser *user                = [SponsorPaySDK instance].user;
    SPBasicDataType dataType    = (SPBasicDataType) (1 << self.selectedPickerIndexPath.row);
    SPUserDataSection section   = (SPUserDataSection) self.selectedPickerIndexPath.section;

    if (section == SPUserDataSectionBasic) {
        switch (dataType) {
            case SPBasicDataTypeGender: {
                SPUserGender enumerator = (index != SPEntryIgnore) ? index : SPUserGenderUndefined;
                [user setGender:enumerator];
                break;
            }

            case SPBasicDataTypeSexualOrientation: {
                SPUserSexualOrientation enumerator = (index != SPEntryIgnore) ? index : SPUserSexualOrientationUndefined;
                [user setSexualOrientation:enumerator];
                break;
            }

            case SPBasicDataTypeEthnicity: {
                SPUserEthnicity enumerator = (index != SPEntryIgnore) ? index : SPUserEthnicityUndefined;
                [user setEthnicity:enumerator];
                break;
            }

            case SPBasicDataTypeLocation: {
                CLLocation *location = (index != SPEntryIgnore) ? [self locationForIndex:index] : nil;
                [user setLocation:location];
                break;
            }

            case SPBasicDataTypeMaritalStatus: {
                SPUserMaritalStatus enumerator = (index != SPEntryIgnore) ? index : SPUserMaritalStatusUndefined;
                [user setMaritalStatus:enumerator];
                break;
            }

            case SPBasicDataTypeEducation: {
                SPUserEducation enumerator = (index != SPEntryIgnore) ? index : SPUserEducationUndefined;
                [user setEducation:enumerator];
                break;
            }

            default:
                break;
        }
    } else {
        switch (dataType) {
            case SPExtraDataTypeConnectionType: {
                SPUserConnectionType enumerator = (index != SPEntryIgnore) ? index : SPUserConnectionTypeUndefined;
                [user setConnectionType:enumerator];
                break;
            }

            case SPExtraDataTypeDevice: {
                SPUserDevice enumerator = (index != SPEntryIgnore) ? index : SPUserDeviceUndefined;
                [user setDevice:enumerator];
                break;
            }

            default:
                break;
        }
    }
}

- (void)setupLocation
{
    // trigger the location update once to allow the app the location access
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];

    if (authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted ) {
        return;
    }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
#endif
    [self.locationManager startUpdatingLocation];
}
//MARK: UIPickerView for pre iOS7

- (void) showModalPickerView:(SPCellType)cellType {

    CGRect screenBounds = [UIScreen mainScreen].bounds;

    UIView *pickerView;

    if (cellType == SPCellTypeCustomPicker) {
        self.customPicker.showsSelectionIndicator = YES;
        pickerView = self.customPicker;
    } else if (cellType == SPCellTypeDatePicker) {
        pickerView = self.datePicker;
    }

    [self.pickerViewContainer addSubview:pickerView];
    pickerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(screenBounds));

    // Add toolbar with done button
    SEL ignoreEntry = @selector(ignoreEntry:);
    SEL addEntry    = @selector(done:);

    UIToolbar *toolBar      = [[UIToolbar alloc]initWithFrame:CGRectZero];
    toolBar.barStyle        = UIBarStyleBlackOpaque;
    UIBarButtonItem *ignore = [[UIBarButtonItem alloc] initWithTitle:@"Ignore entry" style:UIBarButtonItemStyleDone target:self action:ignoreEntry];
    UIBarButtonItem *flex   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:addEntry];
    toolBar.items           = @[ignore, flex, done];
    [toolBar sizeToFit];
    [self.pickerViewContainer addSubview:toolBar];
    toolBar.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(screenBounds));

    // Animate coming from bottom
    [UIView animateWithDuration:0.20 animations:^{
        self.pickerViewContainer.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (finished) {
            CGFloat pickerYPos  = CGRectGetHeight(screenBounds) - CGRectGetHeight(self.customPicker.bounds);
            CGFloat toolbarYPos = pickerYPos - CGRectGetHeight(toolBar.bounds);
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                toolBar.transform           = CGAffineTransformMakeTranslation(0, toolbarYPos);
                pickerView.transform = CGAffineTransformMakeTranslation(0, pickerYPos);
            } completion:nil];
        }
    }];
}

- (void) dismissModalPickerView {
    [UIView animateWithDuration:0.35 animations:^{
        self.pickerViewContainer.alpha = 0.f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.pickerViewContainer removeFromSuperview];
            [self removePickers];
        }
    }];
}

- (void) ignoreEntry:(id)sender {
    [self setValueFromPicker:SPEntryIgnore];

    [self dismissModalPickerView];
    [self.model.tableView reloadData];
}

- (void) done:(id)sender {
    [self dismissModalPickerView];
    [self.model.tableView reloadData];
}

#pragma mark - SPUserSettingsModelDelegate

- (void) showPickerViewForIndexPath:(NSIndexPath *)indexPath {

    SPCellType cellType = [self.model cellTypeForIndexPath:indexPath];
    if (cellType == SPCellTypeCustomPicker || cellType == SPCellTypeDatePicker || cellType == SPCellTypeCustomPickerWithSwitch) {
        self.selectedPickerIndexPath = indexPath;
        if (!IS_iOS7) {
            // Add implementation for pre iOS7 systems
            [self showModalPickerView:cellType];
            return;
        }

        // First of all find out the picker view is already shown somewhere else.
        // If it is apply animation to hide it and then perform animation to show under another cell.

        SPBaseCell *cell = (SPBaseCell *)[self.model.tableView cellForRowAtIndexPath:indexPath];
        if ([self.customPicker superview] || [self.datePicker superview]) {
            [self hidePickerViewWithCompletionBlock:^{
                [self showPickerForCell:cell];
            }];
        } else {
            [self showPickerForCell:cell];
        }
    } else {
        self.selectedPickerIndexPath = nil;
        [self hidePickerViewWithCompletionBlock:nil];

        // If `SPCellTypeBasic` cell is selected create new table view controller
        if (cellType == SPCellTypeBasic) {
            SPUserDynamicTableViewController *interestsViewController = [[SPUserDynamicTableViewController alloc] initWithStyle:UITableViewStylePlain cellStructure:indexPath];

            [self.navigationController pushViewController:interestsViewController animated:YES];
        }

    }
    [self.model.tableView beginUpdates];
    [self.model.tableView endUpdates];
}

- (NSIndexPath *) pickerIndexPath {
    return self.selectedPickerIndexPath;
}

-(void)switchHasChanged:(SPSwitchCell *)cell {
    if (cell.cellType == SPCellTypeCustomPickerWithSwitch) {

//        if (cell.switchControl.isOn) {
//            // disable again if location not available
//            cell.switchControl.on = [CLLocationManager locationServicesEnabledAndAuthorized];
//        } else {
//            SPUser *user = [SponsorPaySDK instance].user;
//            [user setLocation:nil];
//        }
//        [self.model.tableView reloadRowsAtIndexPaths:@[[self.model.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        NSIndexPath *indexPath = [self.model.tableView indexPathForCell:cell];
        NSUInteger dataType = (NSUInteger) (1 << indexPath.row);
        if (indexPath.section) {
            if (dataType == SPExtraDataTypeIap) {
                SPUser *user = [SponsorPaySDK instance].user;
                [user setIap:cell.switchControl.isOn];
            }
        }
    }
}

- (void) reloadLocationForCellAtIndexPath:(NSIndexPath *)indexPath {
    SPUser *user = [SponsorPaySDK instance].user;
        [user dataWithCurrentLocation:^(NSDictionary *data) {
            // reload only if we got a location. In case of Core Location error, we would loop infinitely here.
            if ([user location]) {
                [self.model.tableView beginUpdates];
                [self.model.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.model.tableView endUpdates];
            }
        }];
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSIndexPath *indexPath  = self.selectedPickerIndexPath;
    NSUInteger bitmask     = (NSUInteger) (1 << indexPath.row);
    if (!indexPath.section) {
        return [self.model numberOfComponentsForBasicData:(SPBasicDataType) bitmask];
    } else {
        return [self.model numberOfComponentsForExtraData:(SPExtraDataType) bitmask];
    }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSIndexPath *indexPath  = self.selectedPickerIndexPath;
    NSUInteger bitmask     = (NSUInteger) (1 << indexPath.row);
    if (!indexPath.section) {
        NSString *s = [self.model componentAtIndex:(NSUInteger) row basicDataType:(SPBasicDataType) bitmask];
        return s;
    } else {
        return [self.model componentAtIndex:(NSUInteger) row extraDataType:(SPExtraDataType) bitmask];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *title = [self pickerView:self.customPicker titleForRow:row forComponent:component];

    if ([title isEqualToString:@"Ignore entry"]) {
        row = SPEntryIgnore;
    }

    [self setValueFromPicker:row];

    if (IS_iOS7) {
        [self.model.tableView reloadData];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    SPLogDebug(@"Location authorization changed to %d", status);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
#else
    if (status == kCLAuthorizationStatusAuthorized) {
        [manager startUpdatingLocation];
    }
#endif
}


#pragma mark - Accessors

-(UIPickerView *)customPicker {
    if (!_customPicker) {
        _customPicker               = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _customPicker.dataSource    = self;
        _customPicker.delegate      = self;
    }
    return _customPicker;
}

-(UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker                 = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        _datePicker.datePickerMode  = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    }
    return _locationManager;
}

-(UIView *)pickerViewContainer {
    if (!_pickerViewContainer) {
        CGRect screenBounds                 = [UIScreen mainScreen].bounds;
        UIView *pickerViewContainer         = [[UIView alloc] initWithFrame:screenBounds];
        pickerViewContainer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.35f];  // Dim it
        pickerViewContainer.alpha           = 0.f;           // Initailly not visible
        [pickerViewContainer setUserInteractionEnabled:YES]; // No need for user interaction with table when picker view is up.
                                                             // It would be good if picker view behaves like modal view

        // In order to avoid back view being hidden (as it is by ios default in `presentViewController`) the manual animation must take the place
        SPSampleAppDelegate *delegate = (SPSampleAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:pickerViewContainer];
        _pickerViewContainer = pickerViewContainer;
    }
    return _pickerViewContainer;
}

@end
