//
//  SPStrings.h
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 27.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark  

/*!
    \brief Macro which helps creating functions returning strings for enum 
        literals and constants.
    \param e The enum identifier or the identifier of a constant variable.
    \param r A non-const variable of type NSString* which will receive the
        stringified value of e.

    Use like so:
    
\verbatim

typedef NS_ENUM( NSUInteger, SPMyEnum ) {

    SPMyEnumValue1,
    SPMyEnumValue2,
    
};

// ...

NSString *stringifiedEnum = nil;

switch ( myEnum )
{
SP_ENUM_STRINGIFY_CASE( myEnumValue1, stringifiedEnum )
SP_ENUM_STRINGIFY_CASE( myEnumValue2, stringifiedEnum )
}

\endverbatim
*/
#define SP_ENUM_STRINGIFY_CASE( e, r ) case e: r = SP_ADAPTER_STRINGIFY( e ); \
	break;

/*!
    \brief Convenience macro for creating key constants.
    
    Use like so:
    
\code

SP_KEY( SPSettingsKeyNumberOfBeeps )
SP_KEY( SPSettingsKeyLengthOfBeep )

// ...

NSDictionary * const settings = \@{
    SPSettingsKeyNumberOfBeeps : @( 2 ),
    SPSettingsKeyLengthOfBeep : @( 1.5 )
};

\endcode
*/
#define SP_KEY( name ) static NSString * const name = @ #name;

/*!
    \brief Returns the key for a property while having the compiler check if the
        property exists and is accessible.
    \param obj The object with the property to return the key for.
    \param property The name of the property for which to return the key for.

    This macro prevents out-dated keys used with KVC, KVO, serialisation etc.

    Use like so:
    
\verbatim
    [advertisement
    	addObserver:self 
        forKey:SP_KEY_FOR_PROPERTY( advertisement, displaying )
        options:0
        context:(__bridge void *)[SPSomeObserver class]];
\endverbatim
*/
#define SP_KEY_FOR_PROPERTY( obj, property ) ( sizeof( ( obj ).property ) \
	? @ #property : @ #property )

/*!
    \brief Returns the symbol given as NSString.
    \param something The symbol to be returned as string. May be a pointer,
        variable, reference, type, or enum.
    
    This macro helps to keep messages in-sync with the code. Messages which do
    not reflect the code can be misleading which result in time wasted for
    interpretating and investigating the code.
    
    Use like so:

\verbatim
    NSAssert(
        SPMyEnumMin <= newValue && SPMyEnumMax >= newValue,
        \@"%\@ parameter contains an invalid %\@ value.",
        SP_STRINGIFY( newValue ),   // parameter name could change
        SP_STRINGIFY( SPMyEnum ) ); // Name of enum type could change.
\endverbatim
*/
#define SP_STRINGIFY( something ) ( sizeof( something ) \
	? ( @ #something ) \
    : ( @ #something ) )

#pragma mark  
