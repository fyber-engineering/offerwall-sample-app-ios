//
//  SPDoubleTextFieldCell.h
//  SponsorPayTestApp
//
//  Created by Piotr  on 28/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPBaseCell.h"

@interface SPDoubleTextFieldCell : SPBaseCell

///--------------------------------------------------
/// @name Subclass of `SPBaseCell` with 2 `UITextField`
///--------------------------------------------------

/**
 Outlet to `UITextField` element representing key.

 @see `SPDoubleTextFieldCell.xib`
 */
@property (nonatomic, weak) IBOutlet UITextField *keyTextField;

/**
 Outlet to `UITextField` element representing value.

 @see `SPDoubleTextFieldCell.xib`
 */
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;

@end
