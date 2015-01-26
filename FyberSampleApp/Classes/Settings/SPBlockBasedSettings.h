//
//  SPBlockBasedSettings.h
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 04.06.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPTestAppSettings.h"



//
// Types
//

typedef void (^SPBlockBasedSettingsApplyBlock)( void );
typedef BOOL (^SPBlockBasedSettingsIsAvailableBlock)( void );
typedef SPSettingsState (^SPBlockBasedSettingsStateBlock)( void );



#pragma mark  

@interface SPBlockBasedSettings : SPTestAppSettings

#pragma mark  
#pragma mark Public Methods -

#pragma mark  
#pragma mark Initialising

- (instancetype)initWithName:(NSString *)aLocalizedName 
	description:(NSString *)aLocalizedDescription
    applyBlock:(SPBlockBasedSettingsApplyBlock)anApplyBlock
    isAvailableBlock:(SPBlockBasedSettingsIsAvailableBlock)anIsAvailableBlock
    stateBlock:(SPBlockBasedSettingsStateBlock)aStateBlock;

+ (SPBlockBasedSettings *)settingsWithName:(NSString *)aLocalizedName 
	description:(NSString *)aLocalizedDescription
    applyBlock:(SPBlockBasedSettingsApplyBlock)anApplyBlock
    isAvailableBlock:(SPBlockBasedSettingsIsAvailableBlock)anIsAvailableBlock
    stateBlock:(SPBlockBasedSettingsStateBlock)aStateBlock;

@end

#pragma mark  
