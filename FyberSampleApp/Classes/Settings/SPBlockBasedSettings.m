//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import "SPBlockBasedSettings.h"

// SponsorPay Test App.
#import "SPStrings.h"



#pragma mark  

@interface SPBlockBasedSettings ()

#pragma mark  
#pragma mark Private Properties -

@property ( nonatomic, copy ) SPBlockBasedSettingsApplyBlock applyBlock;
@property ( nonatomic, copy ) SPBlockBasedSettingsIsAvailableBlock isAvailableBlock;
@property ( nonatomic, copy ) SPBlockBasedSettingsStateBlock stateBlock;

@end



#pragma mark  
#pragma mark  
#pragma mark  

@implementation SPBlockBasedSettings
{
@private

    SPBlockBasedSettingsApplyBlock applyBlock;
    SPBlockBasedSettingsIsAvailableBlock isAvailableBlock;
    SPBlockBasedSettingsStateBlock stateBlock;

}

#pragma mark  
#pragma mark Private Properties -

@synthesize applyBlock = applyBlock;
@synthesize isAvailableBlock = isAvailableBlock;
@synthesize stateBlock = stateBlock;

#pragma mark  

- (void)setApplyBlock:(SPBlockBasedSettingsApplyBlock)newApplyBlock
{
    NSAssert( newApplyBlock, @"%@ parameter must not be nil.",
        SP_STRINGIFY( newApplyBlock ) );
    self->applyBlock = [newApplyBlock copy];
}

#pragma mark  
#pragma mark  
#pragma mark Property Overrides -

#pragma mark  
#pragma mark SPSettings: State

- (BOOL)isAvailable
{
    BOOL result = NO;

    SPBlockBasedSettingsIsAvailableBlock const isAvailableBlockOfSelf =
        self.isAvailableBlock;
        
    if ( isAvailableBlockOfSelf )
    {
        result = isAvailableBlockOfSelf();
    }
    
    return result;
}

- (SPSettingsState)state
{
    SPSettingsState result = SPSettingsStateUnknown;
    SPBlockBasedSettingsStateBlock const stateBlockOfSelf = self.stateBlock;
    
    if ( stateBlockOfSelf )
    {
        result = stateBlockOfSelf();
    }
    
    return result;
}

#pragma mark  
#pragma mark  
#pragma mark Public Methods -

#pragma mark  
#pragma mark Initialising

- (instancetype)initWithName:(NSString *)aLocalizedName 
	description:(NSString *)aLocalizedDescription
    applyBlock:(SPBlockBasedSettingsApplyBlock)anApplyBlock
    isAvailableBlock:(SPBlockBasedSettingsIsAvailableBlock)anIsAvailableBlock
    stateBlock:(SPBlockBasedSettingsStateBlock)aStateBlock
{
    self = [super 
    	initWithName:aLocalizedName 
        description:aLocalizedDescription];
    
    if ( self )
    {
        self.applyBlock = anApplyBlock;
        self.isAvailableBlock = anIsAvailableBlock;
        self.stateBlock = aStateBlock;
    }
    
    return self;
}

+ (SPBlockBasedSettings *)settingsWithName:(NSString *)aLocalizedName 
	description:(NSString *)aLocalizedDescription
    applyBlock:(SPBlockBasedSettingsApplyBlock)anApplyBlock
    isAvailableBlock:(SPBlockBasedSettingsIsAvailableBlock)anIsAvailableBlock
    stateBlock:(SPBlockBasedSettingsStateBlock)aStateBlock
{
    return [[self alloc] 
    	initWithName:aLocalizedName 
        description:aLocalizedDescription
        applyBlock:anApplyBlock
        isAvailableBlock:anIsAvailableBlock
        stateBlock:aStateBlock];
}

#pragma mark  
#pragma mark  
#pragma mark Method Overrides -

#pragma mark  
#pragma mark SPSettings: Applying Settings

- (void)apply
{
    SPBlockBasedSettingsApplyBlock applyBlockOfSelf = self.applyBlock;
    
    if ( applyBlockOfSelf )
    {
        applyBlockOfSelf();
    }
}

@end

#pragma mark  
