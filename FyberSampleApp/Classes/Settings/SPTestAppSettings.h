//
//
// Copyright (c) 2015 Fyber. All rights reserved.
//
//

#import <Foundation/Foundation.h>



//
// Types
//

typedef NS_ENUM ( NSUInteger, SPSettingsState ) {

    //!The state of the setting is unknown (for no further specified reasons).
    SPSettingsStateUnknown = 0,
    
    //!The setting is to be found active.
    SPSettingsStateActive,
    
    //!The state of the setting is currently being determined.
    SPSettingsStateDetermining,
    
    //!The setting is not active.
    SPSettingsStateInactive,
    
    SPSettingsStateMin = SPSettingsStateUnknown,
    SPSettingsStateMax = SPSettingsStateInactive

};



#pragma mark  

/*!
    \brief Abstract base class encapsulating settings.
    \see SPSettingsTableViewController
*/
@interface SPTestAppSettings : NSObject

#pragma mark  
#pragma mark Public Properties -

#pragma mark  
#pragma mark Settings

@property ( nonatomic, copy, readonly ) NSString *localizedDescription;
@property ( nonatomic, copy, readonly ) NSString *localizedName;

#pragma mark  
#pragma mark State

/*!
    \brief Denotes if the receiver is active.
    \remarks Evaluates the \c state property in order to compute its return
        value.
        
    If this property is \c YES the setting is active, otherwise it is not.
*/
@property ( nonatomic, assign, readonly, getter = isActive ) BOOL active;

/*!
    \brief Denotes the state of the receiver.
    \note Abstract property. Must be overridden by subclasses.
*/
@property ( nonatomic, assign, readonly ) SPSettingsState state;

/*!
    \brief Returns if the setting is available and thereby can be applied. 
    \note Abstract property. Must be overridden by subclasses.
*/
@property ( nonatomic, assign, readonly, getter = isAvailable ) BOOL available;

#pragma mark  
#pragma mark Public Methods -

#pragma mark  
#pragma mark Initialsing

/*!
    \brief The designated initialiser.
    \param aLocalizedName The localized name of the settings.
    \param aLocalizedDescription The localized description of the settings.
*/
- (instancetype)initWithName:(NSString *)aLocalizedName
    description:(NSString *)aLocalizedDescription;

#pragma mark  
#pragma mark Applying Settings

/*!
    \brief Applies the settings represented by the receiver.
    \note Abstract method. Must be overridden by subclasses.
*/
- (void)apply;

#pragma mark  
#pragma mark Notifying Observers

- (void)notifyDidChangeState;

@end

#pragma mark  
