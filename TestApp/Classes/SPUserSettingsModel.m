//
//  SPUserSettingsModel.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 21/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPUserSettingsModel.h"
#import "SPUserSettingsModel+Mapping.h"
#import "SPUserSettingsViewController.h"
#import "SPTextFieldCell.h"

static NSString * const SPCellTextField     = @"Cell Text Field";
static NSString * const SPCellSwitch        = @"Cell Switch";
static NSString * const SPCellDatePicker    = @"Cell Date Picker";
static NSString * const SPCellCustomPicker  = @"Cell Custom Picker";
static NSString * const SPCellBasic         = @"Cell Basic";

static NSInteger const SPUserSettingsModelSectionCount = 2;

@implementation UIView (SuperView)

- (UIView *)findSuperViewWithClass:(Class)superViewClass {

    UIView *superView = self.superview;
    UIView *foundSuperView = nil;

    while (nil != superView && nil == foundSuperView) {
        if ([superView isKindOfClass:superViewClass]) {
            foundSuperView = superView;
        } else {
            superView = superView.superview;
        }
    }
    return foundSuperView;
}
@end

@interface SPUserSettingsModel () <SPSwitchCellDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation SPUserSettingsModel

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == SPUserDataSectionBasic ? [self.basicKeys count] : [self.extraKeys count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SPUserSettingsModelSectionCount;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == SPUserDataSectionBasic ? @"Basic information" : @"Extra information";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row               = indexPath.row;
    SPUserDataSection section   = (SPUserDataSection) indexPath.section;

    SPCellType cellType = [self cellTypeForIndexPath:indexPath];
    switch (cellType) {
        case SPCellTypeTextField:
        case SPCellTypeNumericField: {
            SPTextFieldCell *cell           = (SPTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:SPCellTextField];
            cell.cellType                   = cellType;
            cell.textField.keyboardType     = (cellType == SPCellTypeNumericField) ? UIKeyboardTypeDecimalPad : UIKeyboardTypeAlphabet;
            NSString *dataFromUser          = [self requestDataForIndexPath:indexPath];
            if (![dataFromUser length] || [dataFromUser integerValue] == SPEntryIgnore) {
                cell.textField.text         = nil;
                cell.textField.placeholder  = [[self textLabelForRow:row section:section] string];
            } else {
                cell.textField.text = dataFromUser;
            }
            cell.textField.delegate         = self;
            cell.textField.backgroundColor  = [UIColor clearColor];
            return cell;
        }

        case SPCellTypeSwitch: {
            NSString *dataFromUser          = [self requestDataForIndexPath:indexPath];
            SPSwitchCell *cell              = (SPSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SPCellSwitch];
            cell.delegate                   = self;
            cell.cellType                   = cellType;
            cell.switchControl.on           = [dataFromUser isEqualToString:@"YES"];
            cell.switchControl.enabled      = YES;
            cell.textLabel.attributedText   = [self textLabelForRow:row section:section];
            return cell;
        }

        case SPCellTypeCustomPickerWithSwitch: {
            NSString *dataFromUser          = [self requestDataForIndexPath:indexPath];
            SPSwitchCell *cell              = (SPSwitchCell *)[tableView dequeueReusableCellWithIdentifier:SPCellSwitch];
            cell.delegate                   = self;
            cell.cellType                   = cellType;
            cell.switchControl.on           = dataFromUser != nil;
            cell.switchControl.enabled      = YES;
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            if ([dataFromUser length]) {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:dataFromUser
                                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                cell.textLabel.attributedText = attrString;
                return cell;
            }
            cell.textLabel.attributedText   = [self textLabelForRow:row section:section];
            return cell;
        }

        case SPCellTypeDatePicker: {
            NSString *dataFromUser          = [self requestDataForIndexPath:indexPath];
            SPBaseCell *cell = (SPBaseCell *)[tableView dequeueReusableCellWithIdentifier:SPCellDatePicker];
            if (!cell) {
                cell = [[SPBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SPCellDatePicker];
            }
            cell.backgroundColor            = [UIColor whiteColor];
            cell.cellType                   = cellType;
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            if ([dataFromUser length]) {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:dataFromUser
                                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                cell.textLabel.attributedText = attrString;
                return cell;
            }
            cell.textLabel.attributedText   = [self textLabelForRow:row section:section];
            return cell;
        }

        case SPCellTypeCustomPicker: {
            NSString *dataFromUser        = [self requestDataForIndexPath:indexPath];
            SPBaseCell *cell = (SPBaseCell *)[tableView dequeueReusableCellWithIdentifier:SPCellCustomPicker];
            if (!cell) {
                cell = [[SPBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SPCellCustomPicker];
            }
            cell.backgroundColor          = [UIColor whiteColor];
            cell.cellType                 = cellType;
            cell.selectionStyle           = UITableViewCellSelectionStyleNone;
            if ([dataFromUser length]) {
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:dataFromUser
                                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                cell.textLabel.attributedText = attrString;
                return cell;
            }
            cell.textLabel.attributedText = [self textLabelForRow:row section:section];
            return cell;
        }

        case SPCellTypeBasic: {
            SPBaseCell *cell = (SPBaseCell *)[tableView dequeueReusableCellWithIdentifier:SPCellBasic];
            if (!cell) {
                cell = [[SPBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SPCellBasic];
            }
            cell.backgroundColor    = [UIColor whiteColor];
            cell.cellType           = cellType;
            cell.textLabel.text     = [[self textLabelForRow:row section:section] string];
            cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_iOS7 && [indexPath compare:[self.delegate pickerIndexPath]] == NSOrderedSame) {
        return 260.f;
    }
    return 44.f;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect Row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // fix for separators bug in iOS 7
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    [self.delegate showPickerViewForIndexPath:indexPath];

    SPCellType cellType = [self cellTypeForIndexPath:indexPath];
    if (cellType != SPCellTypeTextField) {
        if (![self resignFirstResponderForKeys:self.basicKeys section:SPUserDataSectionBasic]) {
            [self resignFirstResponderForKeys:self.extraKeys section:SPUserDataSectionExtra];
        }

    }
}

#pragma mark - SPSwitchCellDelegate

- (void) didChangeSwitchView:(SPSwitchCell *)cell {
    [self.delegate switchHasChanged:cell];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString         = [textField.text stringByReplacingCharactersInRange:range withString:string];
    SPTextFieldCell *cell       = (SPTextFieldCell *)[textField findSuperViewWithClass:[SPTextFieldCell class]];
    NSIndexPath *cellIndexPath  = [self.tableView indexPathForCell:cell];

    NSUInteger dataType = 1 << cellIndexPath.row;
    if (!cellIndexPath.section) {

        switch (dataType) {
            case SPBasicDataTypeAge: {
                [[SponsorPaySDK instance].user setAge:[newString integerValue]];
                break;
            }

            case SPBasicDataTypeZipCode: {
                if(![newString length]) {
                    newString = nil;
                }
                [[SponsorPaySDK instance].user setZipcode:newString];
                break;
            }

            case SPBasicDataTypeAnnualHousholdIncome: {
                [[SponsorPaySDK instance].user setAnnualHouseholdIncome:[newString integerValue]];
                break;
            }
            case SPBasicDataTypeNumberOfChildren: {
                [[SponsorPaySDK instance].user setNumberOfChildren:[newString integerValue]];
            }
            default:
                break;
        }

    } else {

        switch (dataType) {
            case SPExtraDataTypeIapAmount: {
                [[SponsorPaySDK instance].user setIapAmount:[newString floatValue]];
                break;
            }

            case SPExtraDataTypeVersion: {
                [[SponsorPaySDK instance].user setVersion:newString];
                break;
            }

            case SPExtraDataTypeNumberOfSessions: {
                [[SponsorPaySDK instance].user setNumberOfSessions:[newString integerValue]];
                break;
            }

            case SPExtraDataTypePsTime: {
                [[SponsorPaySDK instance].user setPsTime:[newString doubleValue]];
                break;
            }

            case SPExtraDataTypeLastSession: {
                [[SponsorPaySDK instance].user setLastSession:[newString doubleValue]];
                break;
            }
            default:
                break;
        }
    }
    return YES;
}

#pragma mark - Private

- (NSString *) requestDataForIndexPath:(NSIndexPath *)indexPath {

    SPBasicDataType dataType    = 1 << indexPath.row;
    SPUserDataSection section   = indexPath.section;
    SPUser *user                = [SponsorPaySDK instance].user;
    NSString *value;
    if (section == SPUserDataSectionBasic) {
        switch (dataType) {
            case SPBasicDataTypeAge: {
                NSInteger age = [user age];
                value = (age != SPEntryIgnore) ? [@(SPEntryIgnore) stringValue] : [@([user age]) stringValue];
                return value;
            }

            case SPBasicDataTypeBirthday: {
                NSDate *date                = [user birthdate];
                NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
                formatter.dateFormat        = SPUserDateFormat;
                NSString *dateString        = [formatter stringFromDate:date];
                return dateString;
            }

            case SPBasicDataTypeGender: {
                SPUserGender gender = [user gender];
                if (gender == SPUserGenderUndefined) {
                    return nil;
                }
                return SPUserMappingGender[gender];
            }

            case SPBasicDataTypeSexualOrientation: {
                SPUserSexualOrientation sexualOrientation = [user sexualOrientation];
                if (sexualOrientation == SPUserSexualOrientationUndefined) {
                    return nil;
                }
                return SPUserMappingSexualOrientation[sexualOrientation];
            }

            case SPBasicDataTypeEthnicity: {
                SPUserEthnicity ethnicity = [user ethnicity];
                if (ethnicity == SPUserEthnicityUndefined) {
                    return nil;
                }
                return SPUserMappingEthnicity[ethnicity];
            }

            case SPBasicDataTypeLocation: {
                CLLocation *location = [user location];

                if (!location) {
                    [self.delegate reloadLocationForCellAtIndexPath:indexPath];
                }

                // Check mapping for samples
                return [self locationNameForCoordinates:location];
            }

            case SPBasicDataTypeMaritalStatus: {
                SPUserMaritalStatus maritalStatus = [user maritalStatus];
                if (maritalStatus == SPUserMaritalStatusUndefined) {
                    return nil;
                }
                return SPUserMappingMaritalStatus[maritalStatus];
            }

            case SPBasicDataTypeAnnualHousholdIncome: {
                NSInteger income = [user annualHouseholdIncome];
                value = (income != SPEntryIgnore) ? [@(SPEntryIgnore) stringValue] : [@([user annualHouseholdIncome]) stringValue];
                return value;
            }

            case SPBasicDataTypeNumberOfChildren: {
                NSInteger numberOfChildren = [user numberOfChildren];
                value = numberOfChildren != SPEntryIgnore ? [@(SPEntryIgnore) stringValue] : [@([user numberOfChildren]) stringValue];
                return value;
            }

            case SPBasicDataTypeEducation: {
                SPUserEducation education = [user education];
                if (education == SPUserEducationUndefined) {
                    return nil;
                }
                return SPUserMappingEducation[education];
            }

            case SPBasicDataTypeZipCode:
                return [user zipcode];
                
            default:
                return nil;
        }
    } else {
        switch (dataType) {
            case SPExtraDataTypeIap: {
                BOOL iap = [user iap];
                return iap ? @"YES" : @"NO";
            }

            case SPExtraDataTypeIapAmount: {
                float iapAmount = [user iapAmount];
                value = (!iapAmount) ? [@0 stringValue] : [@([user iapAmount]) stringValue];
                return iapAmount ? value : nil;
            }

            case SPExtraDataTypeLastSession: {
                NSTimeInterval lastSession = [user lastSession];
                value = (!lastSession) ? [@0 stringValue] : [@([user lastSession]) stringValue];
                return lastSession ? value : nil;
            }

            case SPExtraDataTypeNumberOfSessions: {
                NSInteger numberOfSessions = [user numberOfSessions];
                value = (!numberOfSessions) ? [@0 stringValue] : [@([user numberOfSessions]) stringValue];
                return numberOfSessions ? value : nil;
            }

            case SPExtraDataTypePsTime:{
                NSTimeInterval psTime = [user psTime];
                value = (!psTime) ? [@0 stringValue] : [@([user psTime]) stringValue];
                return psTime ? value : nil;
            }

            case SPExtraDataTypeConnectionType:{
                SPUserConnectionType connectionType = [user connectionType];
                if (connectionType == SPUserConnectionTypeUndefined) {
                    return nil;
                }
                return SPUserMappingConnectionType[connectionType];
            }

            case SPExtraDataTypeDevice: {
                SPUserDevice device = [user device];
                if (device == SPUserDeviceUndefined) {
                    return nil;
                }
                return SPUserMappingDevice[device];
            }

            case SPExtraDataTypeVersion:
                return [user version];
                
            default:
                return nil;
        }
    }
}

- (BOOL) resignFirstResponderForKeys:(NSArray *)keys section:(SPUserDataSection)section {
    NSInteger index = 0;
    while (index < [keys count]) {
        const NSUInteger i[2]   = {section, index};
        NSIndexPath *indexPath  = [NSIndexPath indexPathWithIndexes:i length:2];
        SPBaseCell *cell        = (SPBaseCell *)[self.tableView cellForRowAtIndexPath:indexPath];

        if ([cell isKindOfClass:[SPTextFieldCell class]]) {
            if ([((SPTextFieldCell *)cell).textField isFirstResponder]) {
                [((SPTextFieldCell *)cell).textField resignFirstResponder];
                return YES;
            }
        }
        index++;
    }
    return NO;
}

- (NSAttributedString *)textLabelForRow:(NSInteger)row section:(SPUserDataSection)section {
    // For better user experience the titles of cells should look different than actual values
    NSString *title;
    if (section == SPUserDataSectionBasic) {
        title = [self.basicKeys[(NSUInteger) row] capitalizedString];
    } else {
        title = [self.extraKeys[(NSUInteger) row] capitalizedString];
    }

    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
}

- (SPCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = (NSUInteger) indexPath.row;
    SPUserDataSection section = (SPUserDataSection) indexPath.section;

    NSUInteger dataType = (NSUInteger) (1 << row);
    if (section == SPUserDataSectionBasic) {

        if (dataType & (SPBasicDataTypeAge |
                        SPBasicDataTypeAnnualHousholdIncome)) {

            return SPCellTypeNumericField;

        } else if (dataType & (SPBasicDataTypeGender |
                               SPBasicDataTypeSexualOrientation |
                               SPBasicDataTypeEthnicity |
                               SPBasicDataTypeMaritalStatus |
                               SPBasicDataTypeEducation)) {

            return SPCellTypeCustomPicker;
        } else if (dataType & SPBasicDataTypeLocation) {
            return SPCellTypeCustomPicker;
        } else if (dataType & SPBasicDataTypeZipCode) {
            return SPCellTypeTextField;
        } else if (dataType & SPBasicDataTypeBirthday) {
            return SPCellTypeDatePicker;
        } else if (dataType & SPBasicDataTypeNumberOfChildren) {
            return SPCellTypeNumericField;
        } else {

            return SPCellTypeBasic;
        }
    } else {
        if (dataType & (SPExtraDataTypeIapAmount |
                        SPExtraDataTypeNumberOfSessions |
                        SPExtraDataTypePsTime |
                        SPExtraDataTypeLastSession)) {

            return SPCellTypeNumericField;

        } else if (dataType & SPExtraDataTypeVersion) {

            return SPCellTypeTextField;
            
        } else if (dataType & SPExtraDataTypeIap) {

            return SPCellTypeSwitch;
            
        } else if (dataType & (SPExtraDataTypeDevice |
                               SPExtraDataTypeConnectionType)) {

            return SPCellTypeCustomPicker;

        } else {

            return SPCellTypeBasic;

        }
    }
}

#pragma mark - Accessors

- (NSArray *)basicKeys
{
    static NSArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[@"age",
                 @"birthdate",
                 @"gender",
                 @"sexual orientation",
                 @"ethnicity",
                 @"location",
                 @"marital status",
                 @"annual household income",
                 @"number of children",
                 @"education",
                 @"zipcode",
                 @"interests"];
    });
    return keys;
}

- (NSArray *)extraKeys
{
    static NSArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[@"iap",
                 @"iap amount",
                 @"number of sessions",
                 @"ps time",
                 @"last session",
                 @"connection type",
                 @"device",
                 @"version",
                 @"custom parameters"];
    });
    return keys;
}

@end
