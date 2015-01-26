//
//  SPSettings.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 04.06.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPTestAppSettings.h"

// SponsorPay Test App
#import "SPStrings.h"



#pragma mark  

#define SP_SETTINGS_OVERRIDE() \
	NSAssert( \
    	NO, \
        @"You are expected to override -[%@ %@].", \
        NSStringFromClass( [SPTestAppSettings class] ), \
        NSStringFromSelector( _cmd ) );\
    \
    [self doesNotRecognizeSelector:_cmd];


#pragma mark  

@interface SPTestAppSettings ()

#pragma mark  
#pragma mark Public Properties Declaration Overrides -

#pragma mark  
#pragma mark Settings

@property ( nonatomic, copy, readwrite ) NSString *localizedDescription;
@property ( nonatomic, copy, readwrite ) NSString *localizedName;

@end




#pragma mark  
#pragma mark  
#pragma mark  

@implementation SPTestAppSettings
{
@private

    //
    // Settings
    //
    
    NSString *localizedDescription;
    NSString *localizedName;

}

#pragma mark  
#pragma mark Public Properties -

#pragma mark  
#pragma mark Settings

@synthesize localizedDescription = localizedDescription;
@synthesize localizedName = localizedName;

#pragma mark  

- (void)setLocalizedName:(NSString *)newLocalizedName
{
    NSAssert(
        [newLocalizedName isKindOfClass:[NSString class]]
            && [[newLocalizedName stringByTrimmingCharactersInSet:
            	[NSCharacterSet whitespaceAndNewlineCharacterSet]] length],
        @"Expecting %@ to be a non-empty, visible string.",
        SP_STRINGIFY( newLocalizedName ) );
    
    self->localizedName = [newLocalizedName copy];
}

#pragma mark  
#pragma mark State

- (BOOL)isActive
{
    return ( SPSettingsStateActive == self.state ) ? YES : NO;
}

- (SPSettingsState)state
{
    SP_SETTINGS_OVERRIDE();
    return SPSettingsStateUnknown;
}

- (BOOL)isAvailable
{
	SP_SETTINGS_OVERRIDE();
    return NO;
}

#pragma mark  
#pragma mark Public Methods -

#pragma mark  
#pragma mark Initialsing

- (instancetype)initWithName:(NSString *)aLocalizedName
    description:(NSString *)aLocalizedDescription
{
    self = [super init];
    
    if ( self ) {
    
        self.localizedDescription = aLocalizedDescription;
        self.localizedName = aLocalizedName;
        
    }
    
    return self;
}

#pragma mark  
#pragma mark Applying Settings

- (void)apply
{
	SP_SETTINGS_OVERRIDE();
}

#pragma mark  
#pragma mark Protocol Methods -

#pragma mark  
#pragma mark NSKeyValueObserving: Observing Customization

+ (NSSet *)keyPathsForValuesAffectingActive
{
    return [[NSSet alloc] initWithArray:@[ 
    	SP_KEY_FOR_PROPERTY( (SPTestAppSettings *)0, state )
    ]];
}

#pragma mark  
#pragma mark Method Overrides -

#pragma mark  
#pragma mark NSObject: Creating, Copying, and Deallocating Objects

- (instancetype)init
{
    NSAssert( 
    	NO,
        @"You must call %@'s designated initialiser %@.",
        NSStringFromClass( [SPTestAppSettings class] ),
        NSStringFromSelector( @selector( initWithName:description: ) ) );
    
    [self doesNotRecognizeSelector:_cmd];
    
    return ( self = nil );
}

#pragma mark  
#pragma mark Notifying Observers

- (void)notifyDidChangeState
{
    [self willChangeValueForKey:SP_KEY_FOR_PROPERTY( self, state )];
    [self didChangeValueForKey:SP_KEY_FOR_PROPERTY( self, state )];
}

@end

#pragma mark  
