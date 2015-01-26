//
//  SPUserSettingsModel+Mapping.h
//  SponsorPayTestApp
//
//  Created by Piotr  on 24/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPUserSettingsModel.h"
#import "SPUserConstants.h"

typedef NS_ENUM(NSInteger, SPUserSampleLocation){
    SPUserSampleLocationBerlin,
    SPUserSampleLocationLondon,
    SPUserSampleLocationNewYork,
    SPUserSampleLocationTokyo,
    SPUserSampleLocationSydney,
    SPUserSampleLocationParis,
    SPUserSampleLocationRoma,
    SPUserSampleLocationLosAngeles
};

typedef NS_OPTIONS(NSUInteger, SPBasicDataType){
    SPBasicDataTypeAge                  = 1 << 0,
    SPBasicDataTypeBirthday             = 1 << 1,
    SPBasicDataTypeGender               = 1 << 2,
    SPBasicDataTypeSexualOrientation    = 1 << 3,
    SPBasicDataTypeEthnicity            = 1 << 4,
    SPBasicDataTypeLocation             = 1 << 5,
    SPBasicDataTypeMaritalStatus        = 1 << 6,
    SPBasicDataTypeAnnualHousholdIncome = 1 << 7,
    SPBasicDataTypeNumberOfChildren     = 1 << 8,
    SPBasicDataTypeEducation            = 1 << 9,
    SPBasicDataTypeZipCode              = 1 << 10,
    SPBasicDataTypeInterests            = 1 << 11
};

typedef NS_OPTIONS(NSUInteger, SPExtraDataType){
    SPExtraDataTypeIap                  = 1 << 0,
    SPExtraDataTypeIapAmount            = 1 << 1,
    SPExtraDataTypeNumberOfSessions     = 1 << 2,
    SPExtraDataTypePsTime               = 1 << 3,
    SPExtraDataTypeLastSession          = 1 << 4,
    SPExtraDataTypeConnectionType       = 1 << 5,
    SPExtraDataTypeDevice               = 1 << 6,
    SPExtraDataTypeVersion              = 1 << 7,
    SPExtraDataTypeCustomParameters     = 1 << 8
};

typedef NS_ENUM(NSUInteger, SPUserDataSection) {
    SPUserDataSectionBasic,
    SPUserDataSectionExtra
};

@interface SPUserSettingsModel (Mapping)

///------------------------------------------------------
/// @name Mapping category of `SPUserSettingsModel` class
///------------------------------------------------------

/**
 Request number of available pre-defined values to choose for basic data
 
 @param dataType `SPBasicDataType` enum type of user basic data type
 @return Number of pre-defined values
 */
- (NSInteger) numberOfComponentsForBasicData:(SPBasicDataType)dataType;

/**
 Request number of available pre-defined values to choose for extra data

 @param dataType `SPExtraDataType` enum type of user extra data type
 @return Number of pre-defined values
 */
- (NSInteger) numberOfComponentsForExtraData:(SPExtraDataType)dataType;

/**
 Request pre-defined value name for basic data at provided index

 @param index Index of pre-defined value
 @param dataType `SPBasicDataType` enum type of user basic data type
 @return Requested value in `NSString` format
 */
- (NSString *) componentAtIndex:(NSUInteger)index basicDataType:(SPBasicDataType)dataType;

/**
 Request pre-defined value name for extra data at provided index

 @param index Index of pre-defined value
 @param dataType `SPExtraDataType` enum type of user extra data type
 @return Requested value in `NSString` format
 */
- (NSString *) componentAtIndex:(NSUInteger)index extraDataType:(SPExtraDataType)dataType;

/**
 Request pre-defined user geo location at provided index

 @param index Index of pre-defined location
 @return `CLLocation` containing information about latitude and longitude
 
 @discussion The pre-defined locations are application based values. They have no relation to SponsorPaySDK and their purpose is solely for testing the `SPUser` functionality.
 */
- (CLLocation *) locationForIndex:(SPUserSampleLocation)index;

/**
 Request pre-defined user geo location name at provided index

 @param location `CLLocation` object
 @return Location name if matches any pre-defined list of locations, otherwise string representing `latitude` and `longitude` values

 @discussion List of location names are application based values. They have no relation to SponsorPaySDK and their purpose is solely for testing the `SPUser` functionality.
 
 @see `-locationForIndex:`
 */
- (NSString *) locationNameForCoordinates:(CLLocation *)location;

@end
