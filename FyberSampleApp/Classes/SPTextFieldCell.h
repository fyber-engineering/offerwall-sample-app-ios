//
//  SPTextFieldCell.h
//  SponsorPayTestApp
//
//  Created by Piotr  on 21/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPBaseCell.h"

@interface SPTextFieldCell : SPBaseCell

///--------------------------------------------------
/// @name Subclass of `SPBaseCell` with `UITextField`
///--------------------------------------------------

/**
 Outlet to `UITextField` element.

 @see `SPTextFieldCell.xib`
 */
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
