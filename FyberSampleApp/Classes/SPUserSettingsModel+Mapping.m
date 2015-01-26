//
//  SPUserSettingsModel+Mapping.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 24/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPUserSettingsModel+Mapping.h"

static NSString *  const SPUserLocationSamples[9] = {
    @"Berlin",
    @"London",
    @"New York",
    @"Tokyo",
    @"Sydney",
    @"Paris",
    @"Roma",
    @"Los Angeles",
    NULL
};

@implementation SPUserSettingsModel (Mapping)

- (NSInteger)numberOfComponentsForBasicData:(SPBasicDataType)dataType {
    NSInteger count = 0;
    switch (dataType) {
        case SPBasicDataTypeEducation:
            while (SPUserMappingEducation[++count]);
            break;

        case SPBasicDataTypeEthnicity:
            while (SPUserMappingEthnicity[++count]);
            break;

        case SPBasicDataTypeGender:
            while (SPUserMappingGender[++count]);
            break;

        case SPBasicDataTypeMaritalStatus:
            while (SPUserMappingMaritalStatus[++count]);
            break;

        case SPBasicDataTypeSexualOrientation:
            while (SPUserMappingSexualOrientation[++count]);
            break;

        case SPBasicDataTypeLocation:
            while (SPUserLocationSamples[++count]);
            break;

        default:
            break;
    }
    if (IS_iOS7) {
        return ++count; // Start from 1 as extra selection `Igonre entry` needs to be added
    } else {
                        // For prerior to iOS7 
        return count;   // In this case there is no need for `Igonre entry` extra cell as the `Igonre entry` will be in toolbar
    }
}

- (NSInteger)numberOfComponentsForExtraData:(SPExtraDataType)dataType {
    NSInteger count = 0;
    switch (dataType) {
        case SPExtraDataTypeConnectionType:
            while (SPUserMappingConnectionType[++count]);
            break;

        case SPExtraDataTypeDevice:
            while (SPUserMappingDevice[++count]);
            break;
            
        default:
            break;
    }
    return ++count; // Start from 1 as extra selection `Igonre entry` needs to be added
}

- (NSString *)componentAtIndex:(NSUInteger)index basicDataType:(SPBasicDataType)dataType {
    NSString *componentTitle;
    switch (dataType) {
        case SPBasicDataTypeEducation:
            componentTitle = SPUserMappingEducation[index];
            break;

        case SPBasicDataTypeEthnicity:
            componentTitle = SPUserMappingEthnicity[index];
            break;

        case SPBasicDataTypeGender:
            componentTitle = SPUserMappingGender[index];
            break;

        case SPBasicDataTypeMaritalStatus:
            componentTitle = SPUserMappingMaritalStatus[index];
            break;

        case SPBasicDataTypeSexualOrientation:
            componentTitle = SPUserMappingSexualOrientation[index];
            break;

        case SPBasicDataTypeLocation:
            componentTitle = SPUserLocationSamples[index];
            break;
            
        default:
            break;
    }

    // when location enabled and authorized, we cannot ignore it. The current location will be sent
    if(!componentTitle && dataType == SPBasicDataTypeLocation && [self locationServicesEnabledAndAuthorized]) {
        componentTitle = @"Current Location";
    }

    if (![componentTitle length]) {
        componentTitle = @"Ignore entry";
    }

    return componentTitle;
}

- (NSString *)componentAtIndex:(NSUInteger)index extraDataType:(SPExtraDataType)dataType {
    switch (dataType) {
        case SPExtraDataTypeConnectionType:
            return SPUserMappingConnectionType[index];
            break;

        case SPExtraDataTypeDevice:
            return SPUserMappingDevice[index];
            break;

        default:
            return nil;
            break;
    }
}

#pragma mark - Location mapping

- (CLLocation *)locationForIndex:(SPUserSampleLocation)index {
    switch (index) {
        case SPUserSampleLocationBerlin: {
            return [[CLLocation alloc] initWithLatitude:52.5075419 longitude:13.4261419];
        }

        case SPUserSampleLocationLondon:{
            return [[CLLocation alloc] initWithLatitude:51.5286416 longitude:-0.1015987];
        }

        case SPUserSampleLocationNewYork:{
            return [[CLLocation alloc] initWithLatitude:42.755942 longitude:-75.8092041];
        }

        case SPUserSampleLocationTokyo:{
            return [[CLLocation alloc] initWithLatitude:35.673343 longitude:139.710388];
        }

        case SPUserSampleLocationSydney:{
            return [[CLLocation alloc] initWithLatitude:-33.7969235 longitude:150.9224326];
        }

        case SPUserSampleLocationParis:{
            return [[CLLocation alloc] initWithLatitude:48.8588589 longitude:2.3470599];
        }

        case SPUserSampleLocationRoma:{
            return [[CLLocation alloc] initWithLatitude:41.9100711 longitude:12.5359979];
        }

        case SPUserSampleLocationLosAngeles:{
            return [[CLLocation alloc] initWithLatitude:34.0204989 longitude:-118.4117325];
        }

        default:
            return nil;
    }
}

- (NSString *)locationNameForCoordinates:(CLLocation *)location {
    if (location.coordinate.latitude == 52.5075419 && location.coordinate.longitude == 13.4261419) {
        return SPUserLocationSamples[0]; // Berlin
    }

    if (location.coordinate.latitude == 51.5286416 && location.coordinate.longitude == -0.1015987) {
        return SPUserLocationSamples[1]; // London
    }

    if (location.coordinate.latitude == 42.755942 && location.coordinate.longitude == -75.8092041) {
        return SPUserLocationSamples[2]; // New York
    }

    if (location.coordinate.latitude == 35.673343 && location.coordinate.longitude == 139.710388) {
        return SPUserLocationSamples[3]; // Tokyo
    }

    if (location.coordinate.latitude == -33.7969235 && location.coordinate.longitude == 150.9224326) {
        return SPUserLocationSamples[4]; // Sydney
    }

    if (location.coordinate.latitude == 48.8588589 && location.coordinate.longitude == 2.3470599) {
        return SPUserLocationSamples[5]; // Paris
    }

    if (location.coordinate.latitude == 41.9100711 && location.coordinate.longitude == 12.5359979) {
        return SPUserLocationSamples[6]; // Roma
    }

    if (location.coordinate.latitude == 34.0204989 && location.coordinate.longitude == -118.4117325) {
        return SPUserLocationSamples[7]; // Los Angeles
    }

    if (!location) {
        return nil;
    }

    return [NSString stringWithFormat:@"%.6g, %.6g", location.coordinate.latitude, location.coordinate.longitude];
}

- (BOOL)locationServicesEnabledAndAuthorized {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    return ([CLLocationManager locationServicesEnabled] &&
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
             [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways));
#else
    return ([CLLocationManager locationServicesEnabled] &&
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);

#endif
    
}

@end
