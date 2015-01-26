//
//  SPBlocks.h
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 27.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark  

#if __has_feature( objc_arc )
#define SP_WEAK_SELF() __weak __typeof__( self )  const weakSelf = self
#else 
#error "Not supported in non-arc environments."
#endif

#if __has_feature( objc_arc )
#define SP_STRONG_SELF() __strong __typeof__( self ) const strongSelf = weakSelf
#else
#error "Not supported in non-arc environments."
#endif

#define SP_STRONG_SELF_RETURN_IF_NIL() SP_STRONG_SELF(); if ( !strongSelf ) \
	return


#pragma mark  
